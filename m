Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A093DF6C7
	for <lists+io-uring@lfdr.de>; Tue,  3 Aug 2021 23:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhHCVRG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Aug 2021 17:17:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbhHCVRF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Aug 2021 17:17:05 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CD6C061757
        for <io-uring@vger.kernel.org>; Tue,  3 Aug 2021 14:16:54 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c16so617318plh.7
        for <io-uring@vger.kernel.org>; Tue, 03 Aug 2021 14:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9q6b8LVbaIr09zNHKVeSaFzoS/EllLqOPwSnekasnqE=;
        b=eQEqTOlHNeqGrRvoLWMVPHj7pe/TkqRi9es/xJf71mWhYbfcr2j5iMA4T9tD/q1jZ0
         K1rnjifKPH5I7uwgoKnWDD46I34XWHmpGXJ11ezHwgbuRvLn2ucBNLepxCaj2a6Q9EkW
         rhbJGORipT7laHlzO/UctyydY3EDEB0enYryxRqVivHhe/zlEH2BXQAXiZxgZY8TTX/1
         1SA3OqfBv69TnR3l7I1sH903CDlF/rrYYYT1sMkUtoWuFXPnBa+tgA4VBynhxfzOZ4mi
         sxtjAPNM+e33HT3Vd21itc0Kgpwe9ELTQ26cN4gplT8GbNfFyqbdlzXwxOUiIMrVPo8I
         IBcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=9q6b8LVbaIr09zNHKVeSaFzoS/EllLqOPwSnekasnqE=;
        b=bb1CFmi96Mw+9SsaabkrKZ1V+y2Oh7NZO334jQH60MFazGY+clIIf10gpFPhtr5i18
         1VBki+T4lA45BbcKhtCfbkJtMKF9X/ti3APgxLvX1wPBOy8JAuh30saO2zNeA8PR4+2V
         GrLlL5sW838Aa2ABWMG+Rkjy/+StNI+Bc+JIza5z7pyVJ8avdQaXg0gVksniForz34Vd
         Use4jdJG8YkzKUCZ3TYvX9lEYye8AdIlB2MuPURehT79ulGYE+8NtVS6GBBdLebUKtTc
         l4JRm6tQ2ezjVamUXiWHO4bIRbc6SuAMXii7iVCt0UdTbZ45h4ZaOQyDDQivFsRUHSjp
         IHpg==
X-Gm-Message-State: AOAM532vr5a8edj00o8cElDiygdZSD0SkHk7kpUOW6pJaiAQ986szTvu
        QdPWjprnSJfUgXhbueLEi3M=
X-Google-Smtp-Source: ABdhPJxNYJJ57g5I6zgGTVPJOBOfPvNsTxpRvHJhVQccYQbb/56JQdLHTBAcdAQC9XcJ+guQ8wlfiQ==
X-Received: by 2002:a17:90a:9483:: with SMTP id s3mr25128080pjo.22.1628025413808;
        Tue, 03 Aug 2021 14:16:53 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id i8sm122785pfo.117.2021.08.03.14.16.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Aug 2021 14:16:53 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Race between io_wqe_worker() and io_wqe_wake_worker()
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <6b51481c-c45e-adf4-51ed-7f7fe927e6b9@kernel.dk>
Date:   Tue, 3 Aug 2021 14:16:51 -0700
Cc:     io-uring@vger.kernel.org, Hao Xu <haoxu@linux.alibaba.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A5ED2B2B-66F8-4A2D-A810-6326CD710042@gmail.com>
References: <BFF746C0-FEDE-4646-A253-3021C57C26C9@gmail.com>
 <5bc88410-6423-2554-340d-ef83f1ba9844@kernel.dk>
 <c6ef9d6c-3127-090f-88a2-a1ffd432bbef@kernel.dk>
 <3CEF2AD7-AD8B-478D-91ED-488E8441988F@gmail.com>
 <612d19fd-a59d-e058-b0bd-1f693bbf647d@kernel.dk>
 <B2A8D1BD-82A1-4EA3-8C7F-B38349D0D305@gmail.com>
 <5f574edb-86ca-2584-dd40-b25fa7bf0517@kernel.dk>
 <6b51481c-c45e-adf4-51ed-7f7fe927e6b9@kernel.dk>
To:     Jens Axboe <axboe@kernel.dk>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



> On Aug 3, 2021, at 12:53 PM, Jens Axboe <axboe@kernel.dk> wrote:
>=20
> How about this? I think this largely stems from the fact that we only
> do a partial running decrement on exit. Left the previous checks in
> place as well, as it will reduce the amount of times that we do need
> to hit that case.

It did not apply cleanly on my 5.13, but after I cleaned it, it still
got stuck (more frequently than when I used your previous solution).

I do not see the problem related to the partial running decrement.
Thinking of it, I think that the problem might even happen if
multiple calls to io_wqe_activate_free_worker() wake up the same worker,
not realizing that they race (since __io_worker_busy() was still not
called by io_worker_handle_work()).

Anyhow, I think there are a few problems in the patch you sent. Once I
addressed a couple of problems, my test passes, but I am not sure you
actually want to final result, and I am not sure it is robust/correct.

See my comments below for the changes I added and other questions I
have (you can answer only if you have time).

>=20
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index cf086b01c6c6..f072995d382b 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -35,12 +35,17 @@ enum {
> 	IO_WQE_FLAG_STALLED	=3D 1,	/* stalled on hash */
> };
>=20
> +enum {
> +	IO_WORKER_EXITING	=3D 0,	/* worker is exiting */
> +};
> +
> /*
>  * One for each thread in a wqe pool
>  */
> struct io_worker {
> 	refcount_t ref;
> 	unsigned flags;
> +	unsigned long state;
> 	struct hlist_nulls_node nulls_node;
> 	struct list_head all_list;
> 	struct task_struct *task;
> @@ -130,6 +135,7 @@ struct io_cb_cancel_data {
> };
>=20
> static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int =
index);
> +static void io_wqe_dec_running(struct io_worker *worker);
>=20
> static bool io_worker_get(struct io_worker *worker)
> {
> @@ -168,26 +174,21 @@ static void io_worker_exit(struct io_worker =
*worker)
> {
> 	struct io_wqe *wqe =3D worker->wqe;
> 	struct io_wqe_acct *acct =3D io_wqe_get_acct(worker);
> -	unsigned flags;
>=20
> 	if (refcount_dec_and_test(&worker->ref))
> 		complete(&worker->ref_done);
> 	wait_for_completion(&worker->ref_done);
>=20
> -	preempt_disable();
> -	current->flags &=3D ~PF_IO_WORKER;
> -	flags =3D worker->flags;
> -	worker->flags =3D 0;
> -	if (flags & IO_WORKER_F_RUNNING)
> -		atomic_dec(&acct->nr_running);
> -	worker->flags =3D 0;
> -	preempt_enable();
> -
> 	raw_spin_lock_irq(&wqe->lock);
> -	if (flags & IO_WORKER_F_FREE)
> +	if (worker->flags & IO_WORKER_F_FREE)
> 		hlist_nulls_del_rcu(&worker->nulls_node);
> 	list_del_rcu(&worker->all_list);
> 	acct->nr_workers--;
> +	preempt_disable();
> +	io_wqe_dec_running(worker);

IIUC, in the scenario I encountered, acct->nr_running might be non-zero,
but still a new worker would be needed. So the check in =
io_wqe_dec_running()
is insufficient to spawn a new worker at this point, no?

> +	worker->flags =3D 0;
> +	current->flags &=3D ~PF_IO_WORKER;
> +	preempt_enable();
> 	raw_spin_unlock_irq(&wqe->lock);
>=20
> 	kfree_rcu(worker, rcu);
> @@ -214,15 +215,20 @@ static bool io_wqe_activate_free_worker(struct =
io_wqe *wqe)
> 	struct hlist_nulls_node *n;
> 	struct io_worker *worker;
>=20
> -	n =3D rcu_dereference(hlist_nulls_first_rcu(&wqe->free_list));
> -	if (is_a_nulls(n))
> -		return false;
> -
> -	worker =3D hlist_nulls_entry(n, struct io_worker, nulls_node);
> -	if (io_worker_get(worker)) {
> -		wake_up_process(worker->task);
> +	/*
> +	 * Iterate free_list and see if we can find an idle worker to
> +	 * activate. If a given worker is on the free_list but in the =
process
> +	 * of exiting, keep trying.
> +	 */
> +	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, =
nulls_node) {
> +		if (!io_worker_get(worker))
> +			continue;

Presumably you want to rely on the order between io_worker_get(), i.e.
the refcount_inc_not_zero() and the test_bit(). I guess no =
memory-barrier
is needed here (since refcount_inc_not_zero() returns a value) but
documentation would help. Anyhow, I do not see how it helps.

> +		if (!test_bit(IO_WORKER_EXITING, &worker->state)) {
> +			wake_up_process(worker->task);

So this might be the main problem. The worker might be in between waking
and setting IO_WORKER_EXITING. One option (that I tried and works, at
least in limited testing), is to look whether the process was actually
woken according to the return value of wake_up_process() and not to
use workers that were not actually woken.

So I changed it to:
                        if (wake_up_process(worker->task)) {
                                io_worker_release(worker);
                                return true;
                        }


> +			io_worker_release(worker);

The refcount is decreased, so the refcount_read in io_wqe_worker()
would not see the elevated refcount. No?

> +			return true;
> +		}
> 		io_worker_release(worker);
> -		return true;
> 	}
>=20
> 	return false;
> @@ -560,8 +566,17 @@ static int io_wqe_worker(void *data)
> 		if (ret)
> 			continue;
> 		/* timed out, exit unless we're the fixed worker */
> -		if (!(worker->flags & IO_WORKER_F_FIXED))
> +		if (!(worker->flags & IO_WORKER_F_FIXED)) {
> +			/*
> +			 * Someone elevated our refs, which could be =
trying
> +			 * to re-activate for work. Loop one more time =
for
> +			 * that case.
> +			 */
> +			if (refcount_read(&worker->ref) !=3D 1)
> +				continue;

I am not sure what it serves, as the refcount is decreased in
io_wqe_activate_free_worker() right after wake_up_process().

Anyhow, presumably you need smp_mb__before_atomic() here, no? I added
one. Yet, without the check in the wake_up_process() this still seems
borken.

> +			set_bit(IO_WORKER_EXITING, &worker->state);
> 			break;
> +		}
> 	}


