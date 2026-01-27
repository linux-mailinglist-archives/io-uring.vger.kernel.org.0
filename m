Return-Path: <io-uring+bounces-11956-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIDIDi8ceWmPvQEAu9opvQ
	(envelope-from <io-uring+bounces-11956-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 21:12:31 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BEED39A415
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 21:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B959E300CC91
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 20:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C91315D5F;
	Tue, 27 Jan 2026 20:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDJ/TleG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB83625
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 20:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769544747; cv=pass; b=SZnMdXVJreZMYryywwOoJlwTop0ps3R8ZPlrLv8LMln1eYVJTDcB7mx0k7OdDonFWiOAicax3lCRlMc/GatJSAUa/eda0AGauGWknwagOmNbAOq40Q51fDArKH0i4uvWbOgAZDJ7aL5NC8Ny4A80Sz2f+c5/L/pC2STVbGmNNYU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769544747; c=relaxed/simple;
	bh=JJBPPVKMZhTyGU22lX0xiVTke3oW6BaBcC3lfwkZzPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dTLnlCT4P0mc5FgPPUhpEJVFnGTCWz8g5qhTtEiR29nPhUOQWgLgULCN/bYwjSCm3rW3670pNmPBGHaTR7bq54bIS8o6F6Q3hBPOFSmV3b+c9Gr65TrrDBNbhXIhYCdEAOXdWqoqACut7GjeFMJb14f5tpLCVretEigbkOH8tKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDJ/TleG; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-502f101d1cfso60664941cf.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 12:12:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769544745; cv=none;
        d=google.com; s=arc-20240605;
        b=TBFYGIhma47aW4/TEXZ2itDpj28wig+npXJkz7jRRPj9Vj/tZ5cNkzOI/l0L1ciaom
         7D3II2Su6lrQTKv8YiDPUxH7AfUToA51JnUFW4RVlHynhoOUP/7HgzrxmOg8DoVQtTla
         HLnbY+J1Smucp686Omv8SpN98ev0vivAMa8ppX3YctqGQcIdFWtWX4qqUXiImnml4SQ1
         Rs+RiD+Xq6Pgx623mUCqCHrB8DnMDLE4qldY6Bj5cLBRdou49wWzOA0kCuD0n9VtFWgV
         tWOK9Xzfygnq/vWKwkB6tJKTGwfnJ1nPYNw4Qsr+CMGAdaTuB6cO65Rcpy13U/FeFart
         pk3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Py+NDYxam+4HyU9vi83DYcaSNUJRmmB3oQfidT43VpU=;
        fh=YznkKBigFX8OItnyhnCnqnDFPX6f5yJ/kjCtDupF3wM=;
        b=N0RUyKalzBGFR7zBHiffkACQnVeKoqL1t1TFE0HyxX6U1VJuMPZRAayb3yfKh5MrAW
         DHoAP8+uSKPzBpY2swKSTvdKHhaCybZz1GpbZX0J8qKxdO86fgX4YKqLlkD+l9xMtEFx
         e0S9haVX730tU5b/yyQ3Wvclk6wFThG/I+QDQBfewO8wCJ1XGrivL4JsR7GU9Rbsp1V/
         F/BX0PFTlHsXXZ5Q78520T/oS5jdvyTE7+ICfeZyR2H5Qdfgw1WALZww5rX4NQBnxDNa
         dCwmzHkW6gN5BFMn4wdvCRO1ikbKrTFj0X+3pjjJ078xSXDHkHu5LFHjBDA6KPm/iRf8
         MJIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769544745; x=1770149545; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Py+NDYxam+4HyU9vi83DYcaSNUJRmmB3oQfidT43VpU=;
        b=CDJ/TleGN4AntUjDnS7nad9XXnU39w08cdluWWf1gXbgH1Hh59ZjgaEebvLgrhizMh
         IML4+OoyBeXlybj1tCGdmZJ9pgKrYXTN8mH2uvC7nRT43XBk16Mt/SpJX1QTVTlXYvfY
         qempUAqL0YEsvp8XsSUbeaQQvHuqQBpnEousEyNMovWMn7DfgTGxhh8yRSDysA9YbgD2
         d94TAmtICaRjSpD89oR5/7oEMNcD7Zrnx4lumMI6fXeMXuMIHYEsNLsveV3L7yaI47qO
         etzCTjfbGIvvZlFhJzvgFrEKL+u2GLQliao4Q89UdCv+IVvtYbDiAnsVdNjTPXkM44L4
         cyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769544745; x=1770149545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Py+NDYxam+4HyU9vi83DYcaSNUJRmmB3oQfidT43VpU=;
        b=dgzdcpd6BwulplGDhGuMRuzE/uIG29FMtc0em5iIKKb7RpjDle3PbU/gHCVZv8EEzy
         49X+lpSBOtj80n05k2DKOUNKCyYxeCuEl70qnQ6ZdJUtw4U3TDptXIuKMNX7+KwK0IKR
         FgWO8Rd3OdO5ErSzi8YsFPq8/eWY8gQ00jEp6bBO9XyEcJ+vzRBUQKZTU0zCNBaxbDmp
         X//2VNT+ZIvPDPMmdsRLYkXxY/9qJg4iAflijlze03DcTBipRundvrM2KVVC6knW/C+E
         0+6PgHfsvQUaKEqXpOrkdtJwpFhnkVI9w2OlX4q5t00e8jX/tmw7Hfn93YzKsPdoQblP
         678w==
X-Forwarded-Encrypted: i=1; AJvYcCVQl/omXxquvDfUwsAzBxFegblheUa1i4G+U+rGJSOLK/Y/3rtE0WaJ0cYor45emm9LFE8SKsL6pQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw+fhw7wnstpye5dlTj1sSFF0BOZRKW0+FNAyrE3kClGdkThM1
	ZtFZLbqw1xsiy6FehWqCeQkf69AURKUnlMJQSbrrUi9NanWH+0sxjeUbSeDAg4cVU7AFQGSnCrN
	J5hvy4H1My4+vysD/SjAupid+m5oXv/U=
X-Gm-Gg: AZuq6aKzMlkKfsT6BX3D2NtOwgy6B6ycdf46IVPqiCgX+lA+bKg1jP0/pJEMs0FJLtk
	FvEkZGrXK7Ijph2FSL65Fm+GuX3CM6lITKx4QYzzsZNRKLyp6OoqV7Bt/cJeoAf8Xlm/3LUixWT
	1z2RijSKiGXM0XxGErL/7su6WmvgAMUm8aHchB8RM6ZWNiigOPaIKMapnbfKk3IfXonuKzTW8RX
	0EiRoekwyPKcKo6+dt5pgAneF5YPE6QwohrEz4CCCiv1FSwoJJdf3ADYxWEZCinvR5iKw==
X-Received: by 2002:a05:622a:189f:b0:4f1:ba4d:deb1 with SMTP id
 d75a77b69052e-5032fa0964fmr38493761cf.46.1769544743289; Tue, 27 Jan 2026
 12:12:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Jan 2026 12:12:11 -0800
X-Gm-Features: AZwV_Qi3POI6J03YkckRItEKw5pFk9mRb8BgUJIg8waJ96yPvnv15BsZkw5x2JU
Message-ID: <CAJnrk1Z-9rsP86Fc=57P9gy=vFjfjT8nuAgE2_snL3_vfbbBmg@mail.gmail.com>
Subject: Re: [PATCH v4 00/25] fuse/io-uring: add kernel-managed buffer rings
 and zero-copy
To: axboe@kernel.dk, miklos@szeredi.hu
Cc: bschubert@ddn.com, csander@purestorage.com, krisman@suse.de, 
	io-uring@vger.kernel.org, asml.silence@gmail.com, xiaobing.li@samsung.com, 
	safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[ddn.com,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11956-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: BEED39A415
X-Rspamd-Action: no action

On Fri, Jan 16, 2026 at 3:31=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> This series adds buffer ring and zero-copy capabilities to fuse over io-u=
ring.
> This requires adding a new kernel-managed buf (kmbuf) ring type to io-uri=
ng
> where the buffers are provided and managed by the kernel instead of by
> userspace.
>
> On the io-uring side, the kmbuf interface is basically identical to pbufs=
.
> They differ mostly in how the memory region is set up and whether it is
> userspace or kernel that recycles back the buffer. Internally, the
> IOBL_KERNEL_MANAGED flag is used to mark the buffer ring as kernel-manage=
d.
>
> The zero-copy work builds on top of the infrastructure added for
> kernel-managed buffer rings (the bulk of which is in patch 19: "fuse: add
> io-uring kernel-managed buffer ring") and that informs some of the design
> choices for how fuse uses the kernel-managed buffer ring without zero-cop=
y.

Could anyone on the fuse side review the fuse changes in patches 19 and 24?

Thanks,
Joanne

>
> There was a previous submission for supporting registered buffers in fuse=
 [1]
> but that was abandoned in favor of using kernel-managed buffer rings, whi=
ch,
> once incremental buffer consumption is added in a later patchset, gives
> significant memory usage advantages in allowing the full buffer capacity =
to be
> utilized across multiple requests, as well as offers more flexibility for
> future additions. As well, it also makes the userspace side setup simpler=
.
> The relevant refactoring fuse patches from the previous submission are ca=
rried
> over into this one.
>
> Benchmarks for zero-copy (patch 24) show approximately the following
> differences in throughput for bs=3D1M:
>
> direct randreads: ~20% increase (~2100 MB/s -> ~2600 MB/s)
> buffered randreads: ~25% increase (~1900 MB/s -> 2400 MB/s)
> direct randwrites: no difference (~750 MB/s)
> buffered randwrites: ~10% increase (950 MB/s -> 1050 MB/s)
>
> The benchmark was run using fio on the passthrough_hp server:
> fio --name=3Dtest_run --ioengine=3Dsync --rw=3Drand{read,write} --bs=3D1M
> --size=3D1G --numjobs=3D2 --ramp_time=3D30 --group_reporting=3D1
>
> This series is on top of commit b71e635feefc in the io-uring tree.
>
> The libfuse changes can be found in [2]. This has a dependency on the lib=
uring
> changes in [3]. To test the server, you can run it with:
> sudo ~/libfuse/build/example/passthrough_hp ~/src ~/mounts/tmp
> --nopassthrough -o io_uring_zero_copy -o io_uring_q_depth=3D8
>
> Thanks,
> Joanne
>
> [1] https://lore.kernel.org/linux-fsdevel/20251027222808.2332692-1-joanne=
lkoong@gmail.com/
> [2] https://github.com/joannekoong/libfuse/tree/zero_copy
> [3] https://github.com/joannekoong/liburing/tree/kmbuf
>
> v3: https://lore.kernel.org/linux-fsdevel/20251223003522.3055912-1-joanne=
lkoong@gmail.com/
> v3 -> v4:
> * Get rid of likely()s and get rid of going through cmd interface layer (=
Gabriel)
> * Fix io_uring_cmd_fixed_index_get() to return back the node pointer (Cal=
eb)
> * Add documentation for io_buffer_register_bvec (Caleb)
> * Remove WARN_ON_ONCE() for io_buffer_unregister() call (Caleb)
>
> v2: https://lore.kernel.org/linux-fsdevel/20251218083319.3485503-1-joanne=
lkoong@gmail.com/
> v2 -> v3:
> * fix casting between void * and u64 for 32-bit architectures (kernel tes=
t robot)
> * add newline for documentation bullet points (kernel test robot)
> * fix unrecognized "boolean" (kernel test robot), switch it to a flag (me=
)
>
> v1: https://lore.kernel.org/linux-fsdevel/20251203003526.2889477-1-joanne=
lkoong@gmail.com/
> v1 -> v2:
> * drop fuse buffer cleanup on ring death, which makes things a lot simple=
r (Jens)
>   - this drops a lot of things (eg needing ring_ctx tracking, needing cal=
lback
>     for ring death, etc)
> * drop fixed buffer pinning altogether and just do lookup every time (Jen=
s)
>   (didn't significantly affect the benchmark results seen)
> * fix spelling mistake in docs (Askar)
> * use -EALREADY for pinning already pinned bufring, return PTR_ERR for
>    registration instead of err, move initializations to outside locks (Ca=
leb)
> * drop fuse patches for zero-ed out headers (me)
>
> Joanne Koong (25):
>   io_uring/kbuf: refactor io_buf_pbuf_register() logic into generic
>     helpers
>   io_uring/kbuf: rename io_unregister_pbuf_ring() to
>     io_unregister_buf_ring()
>   io_uring/kbuf: add support for kernel-managed buffer rings
>   io_uring/kbuf: add mmap support for kernel-managed buffer rings
>   io_uring/kbuf: support kernel-managed buffer rings in buffer selection
>   io_uring/kbuf: add buffer ring pinning/unpinning
>   io_uring/kbuf: add recycling for kernel managed buffer rings
>   io_uring: add io_uring_fixed_index_get() and
>     io_uring_fixed_index_put()
>   io_uring/kbuf: add io_uring_is_kmbuf_ring()
>   io_uring/kbuf: export io_ring_buffer_select()
>   io_uring/kbuf: return buffer id in buffer selection
>   io_uring/cmd: set selected buffer index in __io_uring_cmd_done()
>   fuse: refactor io-uring logic for getting next fuse request
>   fuse: refactor io-uring header copying to ring
>   fuse: refactor io-uring header copying from ring
>   fuse: use enum types for header copying
>   fuse: refactor setting up copy state for payload copying
>   fuse: support buffer copying for kernel addresses
>   fuse: add io-uring kernel-managed buffer ring
>   io_uring/rsrc: rename
>     io_buffer_register_bvec()/io_buffer_unregister_bvec()
>   io_uring/rsrc: split io_buffer_register_request() logic
>   io_uring/rsrc: Allow buffer release callback to be optional
>   io_uring/rsrc: add io_buffer_register_bvec()
>   fuse: add zero-copy over io-uring
>   docs: fuse: add io-uring bufring and zero-copy documentation
>
>  Documentation/block/ublk.rst                  |  14 +-
>  .../filesystems/fuse/fuse-io-uring.rst        |  59 +-
>  drivers/block/ublk_drv.c                      |  18 +-
>  fs/fuse/dev.c                                 |  30 +-
>  fs/fuse/dev_uring.c                           | 692 ++++++++++++++----
>  fs/fuse/dev_uring_i.h                         |  42 +-
>  fs/fuse/fuse_dev_i.h                          |   8 +-
>  include/linux/io_uring/buf.h                  |  25 +
>  include/linux/io_uring/cmd.h                  |  97 ++-
>  include/linux/io_uring_types.h                |  10 +-
>  include/uapi/linux/fuse.h                     |  17 +-
>  include/uapi/linux/io_uring.h                 |  17 +-
>  io_uring/kbuf.c                               | 355 +++++++--
>  io_uring/kbuf.h                               |  19 +-
>  io_uring/memmap.c                             | 117 ++-
>  io_uring/memmap.h                             |   4 +
>  io_uring/register.c                           |   9 +-
>  io_uring/rsrc.c                               | 183 ++++-
>  io_uring/uring_cmd.c                          |   6 +-
>  19 files changed, 1447 insertions(+), 275 deletions(-)
>  create mode 100644 include/linux/io_uring/buf.h
>
> --
> 2.47.3
>

