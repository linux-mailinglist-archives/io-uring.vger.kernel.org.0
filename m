Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B87731B0806
	for <lists+io-uring@lfdr.de>; Mon, 20 Apr 2020 13:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgDTLwr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Apr 2020 07:52:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59476 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbgDTLwr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Apr 2020 07:52:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KBicuc177348;
        Mon, 20 Apr 2020 11:47:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pyDEp0B8MYTB/oYf9L1wbgTIGgi8YX4yYvHYPzEVrL0=;
 b=OFHmQ+4P0RAALfwdU6q/cPTU2f8V4Gfk0BA0/v2359+aKbBm961GPsj2IVwK86TpD1a1
 HgmFl7nADzVdWQCWUrfJpRwUhcL0jaU/xEDmcqIpMC/gLPs0WUxnwfjegGVz+87Voxgz
 C6wvRN+HpIzAaeoiD8SoP5Me8wfaER2cThBmgBsCgGNPT32qlo/IUpyq4BTBx1mXSUBe
 9fq7aeq5qfQ0/7KsyCbJDsWh08umY1IloOxA2sW9dZ4Rdrp3lmla/RhisefBXk3hJw1O
 hrdQ+yBDnvqqkEh7z3lCsFpWzQTKb6/yZ/S6wtm0xxX8UQKYKwUOBLz23ArODTrbG5wq MA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30fsgkpp8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 11:47:33 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KBg779006899;
        Mon, 20 Apr 2020 11:47:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30gb1d1n5p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 11:47:32 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KBlRLF016151;
        Mon, 20 Apr 2020 11:47:27 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 04:47:26 -0700
Date:   Mon, 20 Apr 2020 14:47:19 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Subject: Re: INFO: rcu detected stall in io_uring_release
Message-ID: <20200420114719.GA2659@kadam>
References: <00000000000009dcd905a3954340@google.com>
 <20200419040626.628-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200419040626.628-1-hdanton@sina.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9596 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9596 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1011
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200105
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 19, 2020 at 12:06:26PM +0800, Hillf Danton wrote:
> 
> Sat, 18 Apr 2020 11:59:13 -0700
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    8f3d9f35 Linux 5.7-rc1
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=115720c3e00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=5d351a1019ed81a2
> > dashboard link: https://syzkaller.appspot.com/bug?extid=66243bb7126c410cefe6
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > 
> > Unfortunately, I don't have any reproducer for this crash yet.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+66243bb7126c410cefe6@syzkaller.appspotmail.com
> > 
> > rcu: INFO: rcu_preempt self-detected stall on CPU
> > rcu: 	0-....: (10500 ticks this GP) idle=57e/1/0x4000000000000002 softirq=44329/44329 fqs=5245 
> > 	(t=10502 jiffies g=79401 q=2096)
> > NMI backtrace for cpu 0
> > CPU: 0 PID: 23184 Comm: syz-executor.5 Not tainted 5.7.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  <IRQ>
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x188/0x20d lib/dump_stack.c:118
> >  nmi_cpu_backtrace.cold+0x70/0xb1 lib/nmi_backtrace.c:101
> >  nmi_trigger_cpumask_backtrace+0x231/0x27e lib/nmi_backtrace.c:62
> >  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
> >  rcu_dump_cpu_stacks+0x19b/0x1e5 kernel/rcu/tree_stall.h:254
> >  print_cpu_stall kernel/rcu/tree_stall.h:475 [inline]
> >  check_cpu_stall kernel/rcu/tree_stall.h:549 [inline]
> >  rcu_pending kernel/rcu/tree.c:3225 [inline]
> >  rcu_sched_clock_irq.cold+0x55d/0xcfa kernel/rcu/tree.c:2296
> >  update_process_times+0x25/0x60 kernel/time/timer.c:1727
> >  tick_sched_handle+0x9b/0x180 kernel/time/tick-sched.c:176
> >  tick_sched_timer+0x4e/0x140 kernel/time/tick-sched.c:1320
> >  __run_hrtimer kernel/time/hrtimer.c:1520 [inline]
> >  __hrtimer_run_queues+0x5ca/0xed0 kernel/time/hrtimer.c:1584
> >  hrtimer_interrupt+0x312/0x770 kernel/time/hrtimer.c:1646
> >  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1113 [inline]
> >  smp_apic_timer_interrupt+0x15b/0x600 arch/x86/kernel/apic/apic.c:1138
> >  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:829
> >  </IRQ>
> > RIP: 0010:io_ring_ctx_wait_and_kill+0x98/0x5a0 fs/io_uring.c:7301
> > Code: 01 00 00 4d 89 f4 48 b8 00 00 00 00 00 fc ff df 4c 89 ed 49 c1 ec 03 48 c1 ed 03 49 01 c4 48 01 c5 eb 1c e8 3a ea 9d ff f3 90 <41> 80 3c 24 00 0f 85 53 04 00 00 48 83 bb 10 01 00 00 00 74 21 e8
> > RSP: 0018:ffffc9000897fdf0 EFLAGS: 00000293 ORIG_RAX: ffffffffffffff13
> > RAX: ffff888024082080 RBX: ffff88808df8e000 RCX: 1ffff9200112ffab
> > RDX: 0000000000000000 RSI: ffffffff81d549c6 RDI: ffff88808df8e300
> > RBP: ffffed1011bf1c2c R08: 0000000000000001 R09: ffffed1011bf1c61
> > R10: ffff88808df8e307 R11: ffffed1011bf1c60 R12: ffffed1011bf1c22
> > R13: ffff88808df8e160 R14: ffff88808df8e110 R15: ffffffff81d54ed0
> >  io_uring_release+0x3e/0x50 fs/io_uring.c:7324
> >  __fput+0x33e/0x880 fs/file_table.c:280
> >  task_work_run+0xf4/0x1b0 kernel/task_work.c:123
> >  tracehook_notify_resume include/linux/tracehook.h:188 [inline]
> >  exit_to_usermode_loop+0x2fa/0x360 arch/x86/entry/common.c:165
> >  prepare_exit_to_usermode arch/x86/entry/common.c:196 [inline]
> >  syscall_return_slowpath arch/x86/entry/common.c:279 [inline]
> >  do_syscall_64+0x6b1/0x7d0 arch/x86/entry/common.c:305
> >  entry_SYSCALL_64_after_hwframe+0x49/0xb3
> 
> Make io ring ctx's percpu_ref balanced.
> 
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5904,6 +5904,7 @@ static int io_submit_sqes(struct io_ring
>  fail_req:
>  			io_cqring_add_event(req, err);
>  			io_double_put_req(req);
> +			--submitted;
>  			break;
>  		}


fs/io_uring.c
  5880          for (i = 0; i < nr; i++) {
  5881                  const struct io_uring_sqe *sqe;
  5882                  struct io_kiocb *req;
  5883                  int err;
  5884  
  5885                  sqe = io_get_sqe(ctx);
  5886                  if (unlikely(!sqe)) {
  5887                          io_consume_sqe(ctx);
  5888                          break;
  5889                  }
  5890                  req = io_alloc_req(ctx, statep);
  5891                  if (unlikely(!req)) {
  5892                          if (!submitted)
  5893                                  submitted = -EAGAIN;
  5894                          break;
  5895                  }
  5896  
  5897                  err = io_init_req(ctx, req, sqe, statep, async);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
On the success path io_init_req() takes some references like:

	get_cred(req->work.creds);

That one is probably buggy and should be put if the call to:

	return io_req_set_file(state, req, fd, sqe_flags);

fails...  But io_req_set_file() takes some other references if it
succeeds like percpu_ref_get(req->fixed_file_refs); and it's not clear
that those are released if io_submit_sqe() fails.

  5898                  io_consume_sqe(ctx);
  5899                  /* will complete beyond this point, count as submitted */
  5900                  submitted++;
  5901  
  5902                  if (unlikely(err)) {
  5903  fail_req:
  5904                          io_cqring_add_event(req, err);
  5905                          io_double_put_req(req);
  5906                          break;
  5907                  }
  5908  
  5909                  trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
  5910                                                  true, async);
  5911                  err = io_submit_sqe(req, sqe, statep, &link);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
here

  5912                  if (err)
  5913                          goto fail_req;
  5914          }

regards,
dan carpenter
