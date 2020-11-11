Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBFDD2AF308
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 15:06:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgKKOGF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 09:06:05 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:55912 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726884AbgKKOF0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 09:05:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UF-HYpZ_1605103518;
Received: from 30.5.241.157(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UF-HYpZ_1605103518)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 Nov 2020 22:05:18 +0800
Subject: Re: [bug report] io_uring: refactor io_sq_thread() handling
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <20201111113810.GA1248583@mwanda>
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Message-ID: <09eb9ff4-9680-c330-1904-5ffa391101db@linux.alibaba.com>
Date:   Wed, 11 Nov 2020 22:04:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201111113810.GA1248583@mwanda>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

> Hello Xiaoguang Wang,
> 
> The patch e0c06f5ab2c5: "io_uring: refactor io_sq_thread() handling"
> from Nov 3, 2020, leads to the following static checker warning:
> 
> 	fs/io_uring.c:6939 io_sq_thread()
> 	error: uninitialized symbol 'timeout'.
> 
> fs/io_uring.c
>    6883  static int io_sq_thread(void *data)
>    6884  {
>    6885          struct cgroup_subsys_state *cur_css = NULL;
>    6886          struct files_struct *old_files = current->files;
>    6887          struct nsproxy *old_nsproxy = current->nsproxy;
>    6888          struct pid *old_thread_pid = current->thread_pid;
>    6889          const struct cred *old_cred = NULL;
>    6890          struct io_sq_data *sqd = data;
>    6891          struct io_ring_ctx *ctx;
>    6892          unsigned long timeout;
>                  ^^^^^^^^^^^^^^^^^^^^^^
> 
>    6893          DEFINE_WAIT(wait);
>    6894
>    6895          task_lock(current);
>    6896          current->files = NULL;
>    6897          current->nsproxy = NULL;
>    6898          current->thread_pid = NULL;
>    6899          task_unlock(current);
>    6900
>    6901          while (!kthread_should_stop()) {
>    6902                  int ret;
>    6903                  bool cap_entries, sqt_spin, needs_sched;
>    6904
>    6905                  /*
>    6906                   * Any changes to the sqd lists are synchronized through the
>    6907                   * kthread parking. This synchronizes the thread vs users,
>    6908                   * the users are synchronized on the sqd->ctx_lock.
>    6909                   */
>    6910                  if (kthread_should_park())
>    6911                          kthread_parkme();
>    6912
>    6913                  if (unlikely(!list_empty(&sqd->ctx_new_list))) {
>    6914                          io_sqd_init_new(sqd);
>    6915                          timeout = jiffies + sqd->sq_thread_idle;
>                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> timeout not set on else path.
Thanks for the report, but indeed I think it's not a bug. When io_sq_thread
is created initially, it's not waken up to run, and once it's waken up to run,
it will see that sqd->ctx_new_list is not empty, then timeout always can be
initialized.

Regards,
Xiaoguang Wang

> 
>    6916                  }
>    6917
>    6918                  sqt_spin = false;
>    6919                  cap_entries = !list_is_singular(&sqd->ctx_list);
>    6920                  list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>    6921                          if (current->cred != ctx->creds) {
>    6922                                  if (old_cred)
>    6923                                          revert_creds(old_cred);
>    6924                                  old_cred = override_creds(ctx->creds);
>    6925                          }
>    6926                          io_sq_thread_associate_blkcg(ctx, &cur_css);
>    6927  #ifdef CONFIG_AUDIT
>    6928                          current->loginuid = ctx->loginuid;
>    6929                          current->sessionid = ctx->sessionid;
>    6930  #endif
>    6931
>    6932                          ret = __io_sq_thread(ctx, cap_entries);
>    6933                          if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
>    6934                                  sqt_spin = true;
>    6935
>    6936                          io_sq_thread_drop_mm_files();
>    6937                  }
>    6938
>    6939                  if (sqt_spin || !time_after(jiffies, timeout)) {
>                                                               ^^^^^^^
> warning
> 
>    6940                          io_run_task_work();
>    6941                          cond_resched();
>    6942                          if (sqt_spin)
>    6943                                  timeout = jiffies + sqd->sq_thread_idle;
>    6944                          continue;
>    6945                  }
>    6946
>    6947                  if (kthread_should_park())
>    6948                          continue;
>    6949
>    6950                  needs_sched = true;
>    6951                  prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
>    6952                  list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>    6953                          if ((ctx->flags & IORING_SETUP_IOPOLL) &&
>    6954                              !list_empty_careful(&ctx->iopoll_list)) {
>    6955                                  needs_sched = false;
>    6956                                  break;
>    6957                          }
>    6958                          if (io_sqring_entries(ctx)) {
>    6959                                  needs_sched = false;
>    6960                                  break;
>    6961                          }
>    6962                  }
>    6963
>    6964                  if (needs_sched) {
>    6965                          list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>    6966                                  io_ring_set_wakeup_flag(ctx);
>    6967
>    6968                          schedule();
>    6969                          list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
>    6970                                  io_ring_clear_wakeup_flag(ctx);
>    6971                  }
>    6972
>    6973                  finish_wait(&sqd->wait, &wait);
>    6974                  timeout = jiffies + sqd->sq_thread_idle;
>    6975          }
>    6976
>    6977          io_run_task_work();
>    6978
>    6979          if (cur_css)
>    6980                  io_sq_thread_unassociate_blkcg();
>    6981          if (old_cred)
>    6982                  revert_creds(old_cred);
>    6983
>    6984          task_lock(current);
>    6985          current->files = old_files;
>    6986          current->nsproxy = old_nsproxy;
>    6987          current->thread_pid = old_thread_pid;
>    6988          task_unlock(current);
>    6989
>    6990          kthread_parkme();
>    6991
>    6992          return 0;
>    6993  }
> 
> regards,
> dan carpenter
> 
