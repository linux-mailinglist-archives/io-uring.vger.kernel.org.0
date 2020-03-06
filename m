Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB1C17C41D
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 18:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCFRTM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 12:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:60874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgCFRTM (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 6 Mar 2020 12:19:12 -0500
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C4802084E;
        Fri,  6 Mar 2020 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583515151;
        bh=ZNT0ss7JjyPROQ/EYE1fSxv8lpMdvnRcOY2VqXGe6TM=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=euGkFnvwmKroV4S6/VeLSRciaqnV6DlEDl4NOGcoBo9riVdAPK6yV2PpLrJPe0qCo
         FZNvPKkvaWA0NEwJui4B7ZGcczyrub8t/wRRohDJXq1l7DdCnqgsXByLP39Jm3v4yX
         ieOMBS+uG1S9Nqx6EKpDKtRfOokzGsdMzbrOjP7A=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 6471635226BF; Fri,  6 Mar 2020 09:19:11 -0800 (PST)
Date:   Fri, 6 Mar 2020 09:19:11 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        the arch/x86 maintainers <x86@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
Message-ID: <20200306171911.GA2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <00000000000067c6df059df7f9f5@google.com>
 <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
 <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk>
 <CAG48ez3DUAraFL1+agBX=1JVxzh_e2GR=UpX5JUaoyi+1gQ=6w@mail.gmail.com>
 <075e7fbe-aeec-cb7d-9338-8eb4e1576293@kernel.dk>
 <CAG48ez07bD4sr5hpDhUKe2g5ETk0iYb6PCWqyofPuJbXz1z+hw@mail.gmail.com>
 <20200306164443.GU2935@paulmck-ThinkPad-P72>
 <11921f78-c6f2-660b-5e33-11599c2f9a4b@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11921f78-c6f2-660b-5e33-11599c2f9a4b@kernel.dk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 06, 2020 at 10:00:19AM -0700, Jens Axboe wrote:
> On 3/6/20 9:44 AM, Paul E. McKenney wrote:
> > On Fri, Mar 06, 2020 at 04:36:20PM +0100, Jann Horn wrote:
> >> On Fri, Mar 6, 2020 at 4:34 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>> On 3/6/20 7:57 AM, Jann Horn wrote:
> >>>> +paulmck
> >>>>
> >>>> On Wed, Mar 4, 2020 at 3:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>> On 3/4/20 12:59 AM, Dmitry Vyukov wrote:
> >>>>>> On Fri, Feb 7, 2020 at 9:14 AM syzbot
> >>>>>> <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com> wrote:
> >>>>>>>
> >>>>>>> Hello,
> >>>>>>>
> >>>>>>> syzbot found the following crash on:
> >>>>>>>
> >>>>>>> HEAD commit:    4c7d00cc Merge tag 'pwm/for-5.6-rc1' of git://git.kernel.o..
> >>>>>>> git tree:       upstream
> >>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12fec785e00000
> >>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e162021ddededa72
> >>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e017e49c39ab484ac87a
> >>>>>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> >>>>>>>
> >>>>>>> Unfortunately, I don't have any reproducer for this crash yet.
> >>>>>>>
> >>>>>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> >>>>>>> Reported-by: syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com
> >>>>>>
> >>>>>> +io_uring maintainers
> >>>>>>
> >>>>>> Here is a repro:
> >>>>>> https://gist.githubusercontent.com/dvyukov/6b340beab6483a036f4186e7378882ce/raw/cd1922185516453c201df8eded1d4b006a6d6a3a/gistfile1.txt
> >>>>>
> >>>>> I've queued up a fix for this:
> >>>>>
> >>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=9875fe3dc4b8cff1f1b440fb925054a5124403c3
> >>>>
> >>>> I believe that this fix relies on call_rcu() having FIFO ordering; but
> >>>> <https://www.kernel.org/doc/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.html#Callback%20Registry>
> >>>> says:
> >>>>
> >>>> | call_rcu() normally acts only on CPU-local state[...] It simply
> >>>> enqueues the rcu_head structure on a per-CPU list,
> > 
> > Indeed.  For but one example, if there was a CPU-to-CPU migration between
> > the two call_rcu() invocations, it would not be at all surprising for
> > the two callbacks to execute out of order.
> > 
> >>>> Is this fix really correct?
> >>>
> >>> That's a good point, there's a potentially stronger guarantee we need
> >>> here that isn't "nobody is inside an RCU critical section", but rather
> >>> that we're depending on a previous call_rcu() to have happened. Hence I
> >>> think you are right - it'll shrink the window drastically, since the
> >>> previous callback is already queued up, but it's not a full close.
> >>>
> >>> Hmm...
> >>
> >> You could potentially hack up the semantics you want by doing a
> >> call_rcu() whose callback does another call_rcu(), or something like
> >> that - but I'd like to hear paulmck's opinion on this first.
> > 
> > That would work!
> > 
> > Or, alternatively, do an rcu_barrier() between the two calls to
> > call_rcu(), assuming that the use case can tolerate rcu_barrier()
> > overhead and latency.
> 
> If the nested call_rcu() works, that seems greatly preferable to needing
> the rcu_barrier(), even if that would not be a showstopper for me. The
> nested call_rcu() is just a bit odd, but with a comment it should be OK.
> 
> Incremental here I'm going to test, would just fold in of course.
> 
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f3218fc81943..95ba95b4d8ec 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -5330,7 +5330,7 @@ static void io_file_ref_kill(struct percpu_ref *ref)
>  	complete(&data->done);
>  }
>  
> -static void io_file_ref_exit_and_free(struct rcu_head *rcu)
> +static void __io_file_ref_exit_and_free(struct rcu_head *rcu)
>  {
>  	struct fixed_file_data *data = container_of(rcu, struct fixed_file_data,
>  							rcu);
> @@ -5338,6 +5338,18 @@ static void io_file_ref_exit_and_free(struct rcu_head *rcu)
>  	kfree(data);
>  }
>  
> +static void io_file_ref_exit_and_free(struct rcu_head *rcu)
> +{
> +	/*
> +	 * We need to order our exit+free call again the potentially
> +	 * existing call_rcu() for switching to atomic. One way to do that
> +	 * is to have this rcu callback queue the final put and free, as we
> +	 * could otherwise a pre-existing atomic switch complete _after_
> +	 * the free callback we queued.
> +	 */
> +	call_rcu(rcu, __io_file_ref_exit_and_free);
> +}
> +
>  static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  {
>  	struct fixed_file_data *data = ctx->file_data;

Looks good to me!

							Thanx, Paul
