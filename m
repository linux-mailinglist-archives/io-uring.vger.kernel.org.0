Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13322AEFC0
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 12:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgKKLi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 06:38:26 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39600 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgKKLiX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 06:38:23 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABBUUxC142394;
        Wed, 11 Nov 2020 11:38:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=WGOLGiCyIyq3hvzHJ+onl5mfmI/z071IKcpxSSAg//0=;
 b=bOouFsUlCq5ieprv5V7RqG4boWrb2OKrCvKNdpe9zZCbSuklOTwWjmYxXsrTDzn8R1HF
 kVLtXH0NdSDgp/CR9O6Tb12HTPXaLzvdIoqrjaRXR6HdPVks5cUB5xQdeWNoglvzVYTK
 YvSHyxs/fOrW2g/qRRmSFBknnW1g292c43QvT5lzpcaLENDCdEIfFHHEz7Pe8qlvWb6i
 QhtxH3mokdd/mx1V5ZN/W2d4xkr4MKB1q/usgcJRww/UUUuzB4U609Ez3VM3p5RJW54H
 vzYZQfaEkx1bYiqFBUH4Zj27BTWVf8HfWQYJAhCYSbeFqS+QkVAeE0lyLLuSbvUmBROG yg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhm0eqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 11:38:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ABBZFVZ062284;
        Wed, 11 Nov 2020 11:38:17 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34p55pv92p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 11:38:17 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ABBcGvs022205;
        Wed, 11 Nov 2020 11:38:16 GMT
Received: from mwanda (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 11 Nov 2020 03:38:16 -0800
Date:   Wed, 11 Nov 2020 14:38:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     xiaoguang.wang@linux.alibaba.com
Cc:     io-uring@vger.kernel.org
Subject: [bug report] io_uring: refactor io_sq_thread() handling
Message-ID: <20201111113810.GA1248583@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110067
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=3 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1011 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110066
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Xiaoguang Wang,

The patch e0c06f5ab2c5: "io_uring: refactor io_sq_thread() handling"
from Nov 3, 2020, leads to the following static checker warning:

	fs/io_uring.c:6939 io_sq_thread()
	error: uninitialized symbol 'timeout'.

fs/io_uring.c
  6883  static int io_sq_thread(void *data)
  6884  {
  6885          struct cgroup_subsys_state *cur_css = NULL;
  6886          struct files_struct *old_files = current->files;
  6887          struct nsproxy *old_nsproxy = current->nsproxy;
  6888          struct pid *old_thread_pid = current->thread_pid;
  6889          const struct cred *old_cred = NULL;
  6890          struct io_sq_data *sqd = data;
  6891          struct io_ring_ctx *ctx;
  6892          unsigned long timeout;
                ^^^^^^^^^^^^^^^^^^^^^^

  6893          DEFINE_WAIT(wait);
  6894  
  6895          task_lock(current);
  6896          current->files = NULL;
  6897          current->nsproxy = NULL;
  6898          current->thread_pid = NULL;
  6899          task_unlock(current);
  6900  
  6901          while (!kthread_should_stop()) {
  6902                  int ret;
  6903                  bool cap_entries, sqt_spin, needs_sched;
  6904  
  6905                  /*
  6906                   * Any changes to the sqd lists are synchronized through the
  6907                   * kthread parking. This synchronizes the thread vs users,
  6908                   * the users are synchronized on the sqd->ctx_lock.
  6909                   */
  6910                  if (kthread_should_park())
  6911                          kthread_parkme();
  6912  
  6913                  if (unlikely(!list_empty(&sqd->ctx_new_list))) {
  6914                          io_sqd_init_new(sqd);
  6915                          timeout = jiffies + sqd->sq_thread_idle;
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
timeout not set on else path.

  6916                  }
  6917  
  6918                  sqt_spin = false;
  6919                  cap_entries = !list_is_singular(&sqd->ctx_list);
  6920                  list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
  6921                          if (current->cred != ctx->creds) {
  6922                                  if (old_cred)
  6923                                          revert_creds(old_cred);
  6924                                  old_cred = override_creds(ctx->creds);
  6925                          }
  6926                          io_sq_thread_associate_blkcg(ctx, &cur_css);
  6927  #ifdef CONFIG_AUDIT
  6928                          current->loginuid = ctx->loginuid;
  6929                          current->sessionid = ctx->sessionid;
  6930  #endif
  6931  
  6932                          ret = __io_sq_thread(ctx, cap_entries);
  6933                          if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
  6934                                  sqt_spin = true;
  6935  
  6936                          io_sq_thread_drop_mm_files();
  6937                  }
  6938  
  6939                  if (sqt_spin || !time_after(jiffies, timeout)) {
                                                             ^^^^^^^
warning

  6940                          io_run_task_work();
  6941                          cond_resched();
  6942                          if (sqt_spin)
  6943                                  timeout = jiffies + sqd->sq_thread_idle;
  6944                          continue;
  6945                  }
  6946  
  6947                  if (kthread_should_park())
  6948                          continue;
  6949  
  6950                  needs_sched = true;
  6951                  prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
  6952                  list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
  6953                          if ((ctx->flags & IORING_SETUP_IOPOLL) &&
  6954                              !list_empty_careful(&ctx->iopoll_list)) {
  6955                                  needs_sched = false;
  6956                                  break;
  6957                          }
  6958                          if (io_sqring_entries(ctx)) {
  6959                                  needs_sched = false;
  6960                                  break;
  6961                          }
  6962                  }
  6963  
  6964                  if (needs_sched) {
  6965                          list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
  6966                                  io_ring_set_wakeup_flag(ctx);
  6967  
  6968                          schedule();
  6969                          list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
  6970                                  io_ring_clear_wakeup_flag(ctx);
  6971                  }
  6972  
  6973                  finish_wait(&sqd->wait, &wait);
  6974                  timeout = jiffies + sqd->sq_thread_idle;
  6975          }
  6976  
  6977          io_run_task_work();
  6978  
  6979          if (cur_css)
  6980                  io_sq_thread_unassociate_blkcg();
  6981          if (old_cred)
  6982                  revert_creds(old_cred);
  6983  
  6984          task_lock(current);
  6985          current->files = old_files;
  6986          current->nsproxy = old_nsproxy;
  6987          current->thread_pid = old_thread_pid;
  6988          task_unlock(current);
  6989  
  6990          kthread_parkme();
  6991  
  6992          return 0;
  6993  }

regards,
dan carpenter
