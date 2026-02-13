Return-Path: <io-uring+bounces-12198-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHNbLQt4j2lVRAEAu9opvQ
	(envelope-from <io-uring+bounces-12198-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:14:19 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFF313920F
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 20:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0A8B305B47C
	for <lists+io-uring@lfdr.de>; Fri, 13 Feb 2026 19:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F275727A47F;
	Fri, 13 Feb 2026 19:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IKueb2MI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D800231842
	for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771010056; cv=pass; b=CQEnL8s3Lz+d8n7v+RQAz9kTNQI+QSZsQSVgilnp+eBUdIM8zWKkMP+YpNuZ39xIcsO8xDGjfuuIRghHyKf1eGHB695oxTjHWG0FnxHzHz74KMxOILvO1g5VNZnlxCASZz5S7tmjk36EQXBXUbdlK/L7jqI9R5ju5O/K6nkIHlM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771010056; c=relaxed/simple;
	bh=QMOtojUJUJUOfn1oi3czOpSsj4F+z5Z66cO/fY+2Oyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AgZKdF7XiUYkzEjGld810TJYCfoBNjTOTNGkdfXzMo9Y9wy72ya133qrqdchVR2MN5BTfA4z1to9uWvTLq9UhzMV5cmiUvBYyGV6J1Iz5s6VrEvdF3h/+r0o7RDtZh3guLS9prQIAi77cDH3sO2/FZkCcP+EsmO9U5jjCWeruwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IKueb2MI; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cb3dfb3461so136353285a.3
        for <io-uring@vger.kernel.org>; Fri, 13 Feb 2026 11:14:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771010054; cv=none;
        d=google.com; s=arc-20240605;
        b=d83Ht8h4WMsBfDlw5Pg0LRlMlsV+5glKRHXMkARR15kL4tauMm/UvUDYkNv9gbGegs
         LTEGcxDrz+p0C1JvnNNRMxQBZViUo2XYjFRGUtV2y6wrWUkqCn5GYmqHyO342AczQiwn
         TShLy5lHymVGYpGw6bModTZmd4lSIeDXpN+JgbtRxw5Ulr5yPIZ/0BDCc6qxw7W7NRWs
         Zj3xlXXVDwGuxD7dVqQc0PlnEVc/sI7jZrlQUNZMRa38jZ8pKgmoNJmINIZmLXI46rRh
         JLJV10Y00HwKQXBFGBFmnm8qRo+3LS6qawxAi6Oeql8g4WLZ8mMfsizOJ93yOGjyu+eL
         gKwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2icGgNqwh17ywEcW3vRqwUAR4Y3Ojj4VYlPXxGMjyeg=;
        fh=1Br3OHwRvc47/eX3tN/PKk39IwzBydwAta0o2Qtpb2U=;
        b=UeFoE83TmAKwfSTM9QLj9EGT6aqDOiPAYoi1JLWCI14X4z8h7d+2A8w+0qvxQcYfaV
         0wkytcbNGVciS7njM7WuGh98U88ID0KXspKtMs3j204DAW53Ai/ZFbQUp/lIK1v4CdzN
         7D/XBbYXs7MUJOtoLK3x202MKHEeMc2kqghzwzXGATB6oNmZIdEczaZbJEJT83ofeE7y
         fVbLb2iZrE2UQG5nY61gq17b6SZpDHW6CFKXXkiZPmgb0T2b10ahFBuNYYAIwc6KeOAS
         JtPtWQbw8+1pSFOV6SORdLiMLz1/2+1og6iI4yMr9pZOUP/CTbQbZt58btxL6h6Igo5R
         So+w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771010054; x=1771614854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2icGgNqwh17ywEcW3vRqwUAR4Y3Ojj4VYlPXxGMjyeg=;
        b=IKueb2MITCKF8pg/3KCoImabIfpDMdjepfzvnTJ+v00DGtukDfi0q1AeqrceTHaeFD
         h7+RybH1uMWWsc+F9TyscTA04YbMzZrsbrC9vj3/zXH/XyCiGEAmo22pbaFDYet8kc2J
         edElNFJXAeFMUKzHHSkkduxBa72yeyr+BBzeC6fGCDU+qq0s5qSx4qz22S7zw2mKe46d
         wSaW6u/dH+f7HXCvglbgQh6+beo1omaB1Lrv+KgBBRPy8MI73w0E5YufXl4YsFYNYJAG
         WNUZss6csIwKxTFY919eQEv6t0Iku6UtCJLBaoyMuJULzuJIzrmoOIeZL/z04OIbncOL
         oVFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771010054; x=1771614854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2icGgNqwh17ywEcW3vRqwUAR4Y3Ojj4VYlPXxGMjyeg=;
        b=DR7mxAAtS1NJnh2te3hydwP9KoI2kojMR6/ro5M+ictf7ecrkZJXuAOv8YweLSpF42
         h8jQzhvMHtqErSvCvamJ2T6ioHhe7KeJsS7hoe17Qh//ue8pzurnN+kNdbB9VBdvKcc2
         L7MqLuKcMXfncXrDYy82uu/R9ZX68gNHXbvEzJsZ1+nzVu5LKvNYs/xv3x7313sUuBKU
         bc44gJ2uBr8/goqI5kUvM7ZcCccPNQTeSYGq5jaiHUxwagFEnp8nJWt/4ldx6zHYBANJ
         uS82nAZ817FaG8tnj7e/GPxR7pabahZ0azDkW8zR3npq+3cpXNPuL6SNbZ2GAarwrfq3
         uCkA==
X-Forwarded-Encrypted: i=1; AJvYcCWyT9KDRus8BeK2rir3/QSEhhKv3vKxf+ghziB6N6aug7mX5BgDqw71LBaPDe7waZNTBHp2MxlJLA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwT161nX9b44RbSFOd6Xf0rRoN3oxO3tmz2bG3BCrPhcEqk8D9X
	R/Lxja7S/7cifNrNkUeHjtf+vbuwe9gzGai11lWm1u73A60jc29T9Y2K2Lz2KIzZeAUPD+pi/v+
	Z0r1FXNHJ9samiLSadtp6j+6+gSyxv6w=
X-Gm-Gg: AZuq6aJjEhisEwaeZgOy0ggOlJbA4ZiMGwFsAEf5axsPi6RJghcHmN0W/V9KT/esy1w
	SNDoNAN/ZBJDu/GAU7bxKe4zETPmA0Twa1jh2/Fb+6FlQmgds+NtfvkMS8hBNGxDXk+hSxo6eQZ
	mVCkboPc2Pv3x8JUDScxoAw5kH2HhPQq6pRPiiIP3CE0rjYmYGuh/yjMrb/INcBMnzpeHT2tzP7
	bTJMiNDyAHHzZJL//3i84EOKjCYOODKe6t+yqpGHEp1aBnSi2c55eSYBMec13gIvph52kAI8KEj
	maeuQQ==
X-Received: by 2002:a05:620a:1a26:b0:8ca:90de:43ee with SMTP id
 af79cd13be357-8cb40901644mr400429185a.64.1771010054520; Fri, 13 Feb 2026
 11:14:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
 <20260210002852.1394504-4-joannelkoong@gmail.com> <89c75fc1-2def-4681-a790-78b12b45478a@gmail.com>
 <CAJnrk1ZZyYmwtzcHAnv2x8rt=ZVsz7CXCVV6jtgMMDZytyxp3A@mail.gmail.com>
 <1c657f67-0862-4e13-9c71-7217aeecef61@gmail.com> <CAJnrk1YXmxqUnT561-J7seaicxFRJTyJ=F3_MX1rmtAROC6Ybg@mail.gmail.com>
 <aY2mdLkqPM0KfPMC@infradead.org> <809cd04b-007b-46c6-9418-161e757e0e80@gmail.com>
 <CAJnrk1Y6YSw6Rkdh==RfL==n4qEYrrTcdbbS32sBn12jaCoeXg@mail.gmail.com> <aY7ScyJOp4zqKJO7@infradead.org>
In-Reply-To: <aY7ScyJOp4zqKJO7@infradead.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 13 Feb 2026 11:14:03 -0800
X-Gm-Features: AZwV_QiTvtOJR9T7MW4OboBt-0SXxdh0hnNnA607DbGRo2p_Nnrq0VyV0ScUR8U
Message-ID: <CAJnrk1ZnfdY9j1V8ijWx29jaLcuRH46jpNqR1x5E-Zqfz7MXVg@mail.gmail.com>
Subject: Re: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed
 buffer rings
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk, io-uring@vger.kernel.org, 
	csander@purestorage.com, krisman@suse.de, bernd@bsbernd.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12198-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk,vger.kernel.org,purestorage.com,suse.de,bsbernd.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 1DFF313920F
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 11:27=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Thu, Feb 12, 2026 at 09:29:31AM -0800, Joanne Koong wrote:
> > > > I'm arguing exactly against this.  For my use case I need a setup
> > > > where the kernel controls the allocation fully and guarantees user
> > > > processes can only read the memory but never write to it.  I'd love
> >
> > By "control the allocation fully" do you mean for your use case, the
> > allocation/setup isn't triggered by userspace but is initiated by the
> > kernel (eg user never explicitly registers any kbuf ring, the kernel
> > just uses the kbuf ring data structure internally and users can read
> > the buffer contents)? If userspace initiates the setup of the kbuf
> > ring, going through IORING_REGISTER_MEM_REGION would be semantically
> > the same, except the buffer allocation by the kernel now happens
> > before the ring is created and then later populated into the ring.
> > userspace would still need to make an mmap call to the region and the
> > kernel could enforce that as read-only. But if userspace doesn't
> > initiate the setup, then going through IORING_REGISTER_MEM_REGION gets
> > uglier.
>
> The idea is that the application tells the kernel that it wants to use
> a fixed buffer pool for reads.  Right now the application does this
> using io_uring_register_buffers().  The problem with that is that
> io_uring_register_buffers ends up just doing a pin of the memory,
> but the application or, in case of shared memory, someone else could
> still modify the memory.  If the underlying file system or storage
> device needs verify checksums, or worse rebuild data from parity
> (or uncompress), it needs to ensure that the memory it is operating
> on can't be modified by someone else.

(resending because I hit reply instead of reply-all)

I think we have the exact same use case, except your buffers need to
be read-only. I think your use case benefits from the same memory wins
we'll get with incremental buffer consumption, which is the primary
reason fuse is using a bufring instead of fixed buffers.

>
> So I've been thinking of a version of io_uring_register_buffers where
> the buffers are not provided by the application, but instead by the
> kernel and mapped into the application address space read-only for
> a while, and I thought I could implement this on top of your series,
> but I have to admit I haven't really looked into the details all
> that much.

I think you can and it'll be very easy to do so. All that would be
needed is to pass in a read-only flag from the userspace side when it
registers the bufring, and then when userspace makes the mmap call to
the bufring, the kernel checks if that read-only flag is set on the
bufring and if so returns a read-only mapping. I'm happy to add that
patch to this series if that would make things easier for you. The
io_uring_register_buffers() api registers fixed buffers (which have to
be user-allocated memory) so you would need to go through the
io_uring_register_buf_ring() api once kmbufs are squashed into the
pbuf interface.

With going through IORING_MEM_REGION, this would work for your use
case as well. The user would have to register the mem region with
io_uring_register_region() and pass in a read-only flag, and then the
kernel will allocate the memory region. Then userspace would mmap the
memory region and on the kernel side, it would set the mapping to be
read-only. When the kmbufring then gets registered, the buffers in it
will be empty. The filesystem will then have to populate the buffers
in it from the mem region that was previously registered.

Thanks,
Joanne

>
> >
> > To be completely honest, the more I look at this the more this feels
> > like overkill / over-engineered to me. I get that now the user can do
> > the PMD optimization, but does that actually lead to noticeable
> > performance benefits? It seems especially confusing with them going
> > through the same pbuf ring interface but having totally different
> > expectations.
>
> Yes.  The PMD mapping also is not that relevant.  Both AMD (implicit)
> and ARM (explicit) have optimizations for contiguous PTEs that are
> almost as valuable.
>
> > What about adding a straightforward kmbuf ring that goes through the
> > pbuf interface (eg the design in this patchset) and then in the future
> > adding an interface for pbuf rings (both kernel-managed and
> > non-kernel-managed) to go through IORING_REGISTERED_MEM_REGIONS if
> > users end up needing/wanting to have their rings populated that way?
>
> That feels much simpler to me as well.
>

