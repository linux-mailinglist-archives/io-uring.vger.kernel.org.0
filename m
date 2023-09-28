Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9A07B256C
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 20:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjI1SlG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 14:41:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbjI1SlF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 14:41:05 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8118BF;
        Thu, 28 Sep 2023 11:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695926463; x=1727462463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tfyAzaZSq8tgwhOOpjIAmDGl01NjbJE805eUQRbi27Y=;
  b=a8MpYIGgUetppWcf5xO5A+kodgzcbIiy2JglcgwD1Rq3PNjhAWY6GXEG
   OIvtYlPUSUpeR1PXsFdWhkweexKGIFI82cR7YYrbZ13m+vshMwyaSkyk6
   02ljVkZK0pPw49XHRMedPoq1EQ6TItpTtZLqFYLXmumDcOoV+/awFIg3r
   uq2XeK34pWguhCAWqcg4bTRvN/fNdj8J9YjkxVSUuGGHXJR3IduTE0Q75
   fY3EyIaZTzqCxYZ0hcexqXu0l0HmTHau5mJ3E0063as+8lmDDha6Ymb3Z
   +dD7/tcGkuBw0Hr8W/m+8W+Ri3Gpw1MsdwNwSUuDxIll/1zUIZjsqAKwu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="446296415"
X-IronPort-AV: E=Sophos;i="6.03,184,1694761200"; 
   d="scan'208";a="446296415"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2023 11:34:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10847"; a="996659598"
X-IronPort-AV: E=Sophos;i="6.03,184,1694761200"; 
   d="scan'208";a="996659598"
Received: from lkp-server02.sh.intel.com (HELO c3b01524d57c) ([10.239.97.151])
  by fmsmga006.fm.intel.com with ESMTP; 28 Sep 2023 11:34:21 -0700
Received: from kbuild by c3b01524d57c with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1qlvq6-0001nz-2x;
        Thu, 28 Sep 2023 18:34:18 +0000
Date:   Fri, 29 Sep 2023 02:33:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiaobing Li <xiaobing.li@samsung.com>, mingo@redhat.com,
        peterz@infradead.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, axboe@kernel.dk,
        asml.silence@gmail.com
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, kun.dou@samsung.com,
        peiwei.li@samsung.com, joshi.k@samsung.com,
        kundan.kumar@samsung.com, wenwen.chen@samsung.com,
        ruyi.zhang@samsung.com, Xiaobing Li <xiaobing.li@samsung.com>
Subject: Re: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq
 threads.
Message-ID: <202309290242.FeOyvZYI-lkp@intel.com>
References: <20230928022228.15770-4-xiaobing.li@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230928022228.15770-4-xiaobing.li@samsung.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Xiaobing,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/sched/core]
[also build test ERROR on linus/master v6.6-rc3 next-20230928]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaobing-Li/SCHEDULER-Add-an-interface-for-counting-real-utilization/20230928-103219
base:   tip/sched/core
patch link:    https://lore.kernel.org/r/20230928022228.15770-4-xiaobing.li%40samsung.com
patch subject: [PATCH 3/3] IO_URING: Statistics of the true utilization of sq threads.
config: arm-mmp2_defconfig (https://download.01.org/0day-ci/archive/20230929/202309290242.FeOyvZYI-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230929/202309290242.FeOyvZYI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309290242.FeOyvZYI-lkp@intel.com/

All errors (new ones prefixed by >>):

   io_uring/sqpoll.c:254:7: error: no member named 'sq_avg' in 'struct sched_entity'
                   se->sq_avg.last_update_time;
                   ~~  ^
>> io_uring/sqpoll.c:260:3: error: call to undeclared function '__update_sq_avg_block'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                   __update_sq_avg_block(now, se);
                   ^
   io_uring/sqpoll.c:272:7: error: no member named 'sq_avg' in 'struct sched_entity'
                   se->sq_avg.last_update_time;
                   ~~  ^
>> io_uring/sqpoll.c:275:4: error: call to undeclared function '__update_sq_avg'; ISO C99 and later do not support implicit function declarations [-Werror,-Wimplicit-function-declaration]
                           __update_sq_avg(now, se);
                           ^
   4 errors generated.


vim +/__update_sq_avg_block +260 io_uring/sqpoll.c

   221	
   222	static int io_sq_thread(void *data)
   223	{
   224		struct io_sq_data *sqd = data;
   225		struct io_ring_ctx *ctx;
   226		unsigned long timeout = 0;
   227		char buf[TASK_COMM_LEN];
   228		DEFINE_WAIT(wait);
   229	
   230		snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
   231		set_task_comm(current, buf);
   232	
   233		if (sqd->sq_cpu != -1)
   234			set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
   235		else
   236			set_cpus_allowed_ptr(current, cpu_online_mask);
   237	
   238		mutex_lock(&sqd->lock);
   239		bool first = true;
   240		struct timespec64 ts_start, ts_end;
   241		struct timespec64 ts_delta;
   242		struct sched_entity *se = &sqd->thread->se;
   243		while (1) {
   244			bool cap_entries, sqt_spin = false;
   245	
   246			if (io_sqd_events_pending(sqd) || signal_pending(current)) {
   247				if (io_sqd_handle_event(sqd))
   248					break;
   249				timeout = jiffies + sqd->sq_thread_idle;
   250			}
   251			ktime_get_boottime_ts64(&ts_start);
   252			ts_delta = timespec64_sub(ts_start, ts_end);
   253			unsigned long long now = ts_delta.tv_sec * NSEC_PER_SEC + ts_delta.tv_nsec +
   254			se->sq_avg.last_update_time;
   255	
   256			if (first) {
   257				now = 0;
   258				first = false;
   259			}
 > 260			__update_sq_avg_block(now, se);
   261			cap_entries = !list_is_singular(&sqd->ctx_list);
   262			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
   263				int ret = __io_sq_thread(ctx, cap_entries);
   264	
   265				if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
   266					sqt_spin = true;
   267			}
   268	
   269			ktime_get_boottime_ts64(&ts_end);
   270			ts_delta = timespec64_sub(ts_end, ts_start);
   271			now = ts_delta.tv_sec * NSEC_PER_SEC + ts_delta.tv_nsec +
   272			se->sq_avg.last_update_time;
   273	
   274			if (sqt_spin)
 > 275				__update_sq_avg(now, se);
   276			else
   277				__update_sq_avg_block(now, se);
   278			if (io_run_task_work())
   279				sqt_spin = true;
   280	
   281			if (sqt_spin || !time_after(jiffies, timeout)) {
   282				if (sqt_spin)
   283					timeout = jiffies + sqd->sq_thread_idle;
   284				if (unlikely(need_resched())) {
   285					mutex_unlock(&sqd->lock);
   286					cond_resched();
   287					mutex_lock(&sqd->lock);
   288				}
   289				continue;
   290			}
   291	
   292			prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
   293			if (!io_sqd_events_pending(sqd) && !task_work_pending(current)) {
   294				bool needs_sched = true;
   295	
   296				list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
   297					atomic_or(IORING_SQ_NEED_WAKEUP,
   298							&ctx->rings->sq_flags);
   299					if ((ctx->flags & IORING_SETUP_IOPOLL) &&
   300					    !wq_list_empty(&ctx->iopoll_list)) {
   301						needs_sched = false;
   302						break;
   303					}
   304	
   305					/*
   306					 * Ensure the store of the wakeup flag is not
   307					 * reordered with the load of the SQ tail
   308					 */
   309					smp_mb__after_atomic();
   310	
   311					if (io_sqring_entries(ctx)) {
   312						needs_sched = false;
   313						break;
   314					}
   315				}
   316	
   317				if (needs_sched) {
   318					mutex_unlock(&sqd->lock);
   319					schedule();
   320					mutex_lock(&sqd->lock);
   321				}
   322				list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
   323					atomic_andnot(IORING_SQ_NEED_WAKEUP,
   324							&ctx->rings->sq_flags);
   325			}
   326	
   327			finish_wait(&sqd->wait, &wait);
   328			timeout = jiffies + sqd->sq_thread_idle;
   329		}
   330	
   331		io_uring_cancel_generic(true, sqd);
   332		sqd->thread = NULL;
   333		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
   334			atomic_or(IORING_SQ_NEED_WAKEUP, &ctx->rings->sq_flags);
   335		io_run_task_work();
   336		mutex_unlock(&sqd->lock);
   337	
   338		complete(&sqd->exited);
   339		do_exit(0);
   340	}
   341	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
