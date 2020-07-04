Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C5D21427C
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 03:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgGDBNJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Jul 2020 21:13:09 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:52745 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726455AbgGDBNJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Jul 2020 21:13:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1C7255C00E9;
        Fri,  3 Jul 2020 21:13:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 03 Jul 2020 21:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:in-reply-to:references:mime-version:content-type
        :content-transfer-encoding:subject:to:from:message-id; s=fm2;
         bh=UsNgsQLolBnKiIWV9ruZCr9kW6lxvxrt0QRB9xicWcA=; b=eCZxtXgaZK4G
        6ezOtfZ7fJ8SAGG60vRt7mQWZN6d7wr3QYkzGEaySKjHWAe5IoyYXMrsMAoMkLa3
        d2zpHcRx9XUvYHh4/6RoCCLTDPE5Lgla7prkYLFxwQvFJZ/B0+QvQaUJ2zZJLRPo
        vJOr7nCG/9S38mTgw9Yj/OUV/dZLDQ74dA7o+gdbZlHNvwmdC84fnwgK1GzFVc6d
        FdJVsBYZNEPOKcP9+HPR6zVPmmZuKrA39zEc8rn46lNa4FbDSP/FnyZzokfMSPJF
        a2p0omluvG9A9GvCsh6fVSg2TWa9ZSFEQWEmG8DWlJjKbkSIhZtPANqUbdvuHvZr
        qLFMuYsPEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=UsNgsQLolBnKiIWV9ruZCr9kW6lxvxrt0QRB9xicW
        cA=; b=gMAhUiBA58viYPkQvW12C4Vswg8iKA/jnAeVZX78XXFJq7uRtTIkzHDUZ
        0tFF2D/rchW5BmWv3JJT2L0U+iOWvdh3hZR+0uKV/O8j4uWzT4XjVSlp92daxkBQ
        n4+JfI66pgYtlbCRtbFQ7rAp2bdY+Dzr85Jvbos71SZulSbn9ZMflFgkyJuRUzVx
        6BrEco67XQMHiRtzPYSPOgZZsSW/MZP5ZblO3kc0pu1tNaDIVl8JAZ6fJ/UvQwtB
        usfUuN1uQlcy7UmX8UbHDVpkEj9i/9oi5MbtLmGqASaWnJQGmbEFrMIe45NBEetU
        kNyhitQE6aHuzKyNG2bxrOtGj4SyA==
X-ME-Sender: <xms:otf_XtAtzML_rdYhrbUP8aBySH8jGCCAY-A8fGmhQZl_javWdybF1w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdejgdeggecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefffggjfhggtgfguffvhffksehtqhhmtddtreejnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvheeivedvhedvveefjeefkeefteehffeihfeugeeiledvtdeuueefgeej
    feejteenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:otf_Xrh9zkVNzPKFAKMJaJWj0m3oW2TqJObyhIkxR5_vUhHTrg3TGw>
    <xmx:otf_Xokv36p4K5yNKzLfRQZ6ajl7VYGc1JmkSsAlAR2DVOxYW7b0yQ>
    <xmx:otf_Xny_6ypLTYOAS4NYVezKPQ8tQt556G0uObSrHCUwFtc2Ak9bNw>
    <xmx:o9f_XpeCJkiVbKYMsJN_1bG02qNnzmY0UHhJeOU-sbSlKqiKf5vxaQ>
Received: from ahand.lan (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7034C3280059;
        Fri,  3 Jul 2020 21:13:06 -0400 (EDT)
Date:   Fri, 03 Jul 2020 18:13:05 -0700
User-Agent: K-9 Mail for Android
In-Reply-To: <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
References: <20200704000049.3elr2mralckeqmej@alap3.anarazel.de> <20200704001541.6isrwsr6ptvbykdq@alap3.anarazel.de> <70fb9308-2126-052b-730a-bc5adad552f9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: signals not reliably interrupting io_uring_enter anymore
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
From:   Andres Freund <andres@anarazel.de>
Message-ID: <7C9DC2D8-6FF5-477D-B539-3A9F5DE1B13B@anarazel.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,=20

On July 3, 2020 5:48:21 PM PDT, Jens Axboe <axboe@kernel=2Edk> wrote:
>On 7/3/20 6:15 PM, Andres Freund wrote:
>> Hi,
>>=20
>> On 2020-07-03 17:00:49 -0700, Andres Freund wrote:
>>> I haven't yet fully analyzed the problem, but after updating to
>>> cdd3bb54332f82295ed90cd0c09c78cd0c0ee822 io_uring using postgres
>does
>>> not work reliably anymore=2E
>>>
>>> The symptom is that io_uring_enter(IORING_ENTER_GETEVENTS) isn't
>>> interrupted by signals anymore=2E The signal handler executes, but
>>> afterwards the syscall is restarted=2E Previously io_uring_enter
>reliably
>>> returned EINTR in that case=2E
>>>
>>> Currently postgres relies on signals interrupting io_uring_enter()=2E
>We
>>> probably can find a way to not do so, but it'd not be entirely
>trivial=2E
>>>
>>> I suspect the issue is
>>>
>>> commit ce593a6c480a22acba08795be313c0c6d49dd35d (tag:
>io_uring-5=2E8-2020-07-01, linux-block/io_uring-5=2E8)
>>> Author: Jens Axboe <axboe@kernel=2Edk>
>>> Date:   2020-06-30 12:39:05 -0600
>>>
>>>     io_uring: use signal based task_work running
>>>
>>> as that appears to have changed the error returned by
>>> io_uring_enter(GETEVENTS) after having been interrupted by a signal
>from
>>> EINTR to ERESTARTSYS=2E
>>>
>>>
>>> I'll check to make sure that the issue doesn't exist before the
>above
>>> commit=2E
>>=20
>> Indeed, on cd77006e01b3198c75fb7819b3d0ff89709539bb the PG issue
>doesn't
>> exist, which pretty much confirms that the above commit is the issue=2E
>>=20
>> What was the reason for changing EINTR to ERESTARTSYS in the above
>> commit? I assume trying to avoid returning spurious EINTRs to
>userland?
>
>Yeah, for when it's running task_work=2E I wonder if something like the
>below will do the trick?
>
>
>diff --git a/fs/io_uring=2Ec b/fs/io_uring=2Ec
>index 700644a016a7=2E=2E0efa73d78451 100644
>--- a/fs/io_uring=2Ec
>+++ b/fs/io_uring=2Ec
>@@ -6197,11 +6197,11 @@ static int io_cqring_wait(struct io_ring_ctx
>*ctx, int min_events,
> 	do {
> 		prepare_to_wait_exclusive(&ctx->wait, &iowq=2Ewq,
> 						TASK_INTERRUPTIBLE);
>-		/* make sure we run task_work before checking for signals */
>-		if (current->task_works)
>-			task_work_run();
> 		if (signal_pending(current)) {
>-			ret =3D -ERESTARTSYS;
>+			if (current->task_works)
>+				ret =3D -ERESTARTSYS;
>+			else
>+				ret =3D -EINTR;
> 			break;
> 		}
> 		if (io_should_wake(&iowq, false))
>@@ -6210,7 +6210,7 @@ static int io_cqring_wait(struct io_ring_ctx
>*ctx, int min_events,
> 	} while (1);
> 	finish_wait(&ctx->wait, &iowq=2Ewq);
>=20
>-	restore_saved_sigmask_unless(ret =3D=3D -ERESTARTSYS);
>+	restore_saved_sigmask_unless(ret =3D=3D -EINTR);
>=20
>	return READ_ONCE(rings->cq=2Ehead) =3D=3D READ_ONCE(rings->cq=2Etail) ? =
ret :
>0;
> }

I'll try in a bit=2E Suspect however that there'd be trouble if there were=
 both an actual signal and task work pending?

Andres
--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
