Return-Path: <io-uring+bounces-12337-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GH5PC3lCl2lXwAIAu9opvQ
	(envelope-from <io-uring+bounces-12337-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:03:53 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A92D8160E94
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 18:03:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1F7763016EC4
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B80834B1A1;
	Thu, 19 Feb 2026 17:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IWm6GpBO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8783334D4FE
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 17:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771520621; cv=pass; b=L6EnTvY4ysVsGTWcv6r2nHTbCLu2QiHR/Qf1OSw9cmETlkogQfHtO17NYYZzHxfIDMiFGfGHmhL44wG6oWkbF9SEgsImofDbqO8/CmlFGa/CDSbS8/+KCANu3UBUMdU+qYb0s2ox6KvpMnlV1ndbCnJT7SGoPbBxW3FGEw5VrY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771520621; c=relaxed/simple;
	bh=tBiZ17iwfft0wbQAGLtoaADnrAgBOfJOHZF3aeqDH40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KJpa+I+5zbSXeJZ6Ezdgicn0HDVUgGGqS528BpYGYnNypPQnBzPrNBgf8QtBX/mAn16rDf6r0SUSk5I9kP+WvSC/JA4as7kPYN2hQz3OlvAEYvTk5XlpFTEYSqX3Yn2s7zHBkAJKvh9KFjIuNKfZJ1tNba0JbtOGKJNdh+3NxUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IWm6GpBO; arc=pass smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8fb8858537so15295966b.3
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 09:03:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771520618; cv=none;
        d=google.com; s=arc-20240605;
        b=Mwwab/l12BuKVDuWyBXqvB+rtahz73HVY+kwg4MBP7OesKPIwdO/n53K7IDqULTTCm
         AU/Cbf2PqOWSi13kyEiWkuEci+WJWcwP70raUWZ0QtMvv5x7AJVzZn8HCttxgEG7MW0i
         ivcT6BTGrUVEdneOmJ5oSciw0AvhXrnlRgeZmrmnBGIeDZA4oaO82LCHtnj4CzaP2jzl
         5UCXhouyFEXWr5GaZyffONSvh8csACYoXBgziOxLk9X+9jSxBoKFUYvlsRJvN4IBLIby
         kewmlejts0JUV/EifLyU1nb5KulPM72q8hU7BLsX95/5TNbSSYGpj21kIvUAWSPOoUKU
         BM/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tBiZ17iwfft0wbQAGLtoaADnrAgBOfJOHZF3aeqDH40=;
        fh=w2o4NTM+3YKEXMtqQLnxzSAAHw/gDnNWD1dSrZXGz28=;
        b=j8PLLSjhHHnhou9nKLbAXSgONsiP5AsfpEIgm2mwjWLGsfNhtA2kQqlZM0d2SrB1q6
         b5MqYEWCCFAe+HygFQCe+Qk2iNMk2DGcNeus3jVqB1b9DqteSxClu82LgR8AWRXWqKcM
         c1MjHzvj8dxIsIUFIHmXyTL7l9idNMqL130AIoSzfbWgS0P/Mun2cKgTY5AyZX9yMY9Q
         /p5UuaU+sr5RYfntaNB9wzbaZeKMYgVkQ9i8K7QOd2uPbdFMhrOBLWTSK50/hFB9AS7m
         qkbfSuYLS0FCtpO+PQylrqccfyUJTAoSDEgZ7UJ+fYzpJ/sqnGQw3t0z71qYEYZsADlq
         o+RQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771520618; x=1772125418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBiZ17iwfft0wbQAGLtoaADnrAgBOfJOHZF3aeqDH40=;
        b=IWm6GpBOpq4wQhzJhReGzdFFVGq7gCEuI3MFM4s8Y2sJGPnxnHWsk69LIk35AA6VEV
         KbYIGaIAcx4OnCrXaUKL/0BAByPpHLOzZ38zTAociTn3/AuU6TSoiXczA5DfJy/x5YtP
         FJI0sShbQ35JWrpvZtaYCkFc5gku34NKCG6gRCkvSBSRKGC9/4/svPVcLh7paaipeKB/
         nzBcapI4lsapClo83UryzoJz/h2iKStCKq4bQitSXMqOPXzP8eyPXzRMbuxiIwPSRKsO
         GkgrzCkQwGxv/CtMPsaM06MJAgVHGIIEUA5HJBciAjr6eD+lmJshZelD9nhUMDXRskYe
         4/Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771520618; x=1772125418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tBiZ17iwfft0wbQAGLtoaADnrAgBOfJOHZF3aeqDH40=;
        b=GC0+jDqQymnP2umd97xM0gC9M7k4KHPUgibZOB4O8IIF4QH7jcQK4BxlEnqiIU02Cy
         wpO/E3HOfMbUShIRkT6GsXnCauZFklde+e8IJbQWTebci6eZDDhbbtfYVUk1Vtae5uH8
         Aa+WZzia6YxJDkcsPvYf/CgIWFHqh5iP3J+xnnAxAhr08cL/+Jck/sL/74MZXYbjlbIi
         DYaeI2JVmxW7vYvMabvxw59D4tK+/x0RtDduyr7Fk6DWKlMnp1gEp0aZF1mkTmx5Sq59
         N8zWHQUBHNJvOloqXMPEWBR0jecbBWFz6ERIftLhmhOD4Wq/CmDwxJSURCTU0izq0sCq
         /ZnA==
X-Forwarded-Encrypted: i=1; AJvYcCXYhUo14UhBka0JvxLxX5JMasxT7r2nk4PjyOorcT2ypATxjuU275fLowZQEyw1rIS/GuqMVXysJw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxHAHoW6Ii2bqS3R+d0nQ8mSAJBJqvqlnXkJ1QazsTm8UoVdQJF
	+Mui3ggAteI1iJ38tvpu0YilpiLSQSWc5SMvjMjZ07ep+SZOOxstXeI3GConOkWjAio1+hvgOal
	4ftV9fr+ZbEPAnFPn8wPZdAQlrqiCCSitq/A1PNGY2g==
X-Gm-Gg: AZuq6aL3h7SRy8kA+sScAZqwApB/nPasOpRe1aP9NvLUxurOMdrPdnXoxd8xBRW5Eiq
	ogUNlwWvxqaEWJFqF7aTC8P111bJAoIhnl8b43cjHiUgza/fnZ21xi4l/lporF54zyUdk3lIlc9
	uA95e3jZfFVhb30IW9TpPjzRs78fnCio4skXIy/qP9FdTw/25rFAzY7tFIaMmwy4n8HJKlGVKuI
	vMH7ChQphxFYbjQjS8SnUXu4qLrQguAIec6lPiH4QXX1+8hsBdBSivnQqPKSbQW/Tk5FX7Lw/xn
	+bPpAd0k
X-Received: by 2002:a17:907:3e88:b0:b87:2099:9f6b with SMTP id
 a640c23a62f3a-b8face2491bmr719909166b.3.1771520617544; Thu, 19 Feb 2026
 09:03:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20260219014357epcas5p31a24ed7f17ebfe2d15f850c2a4114ebe@epcas5p3.samsung.com>
 <20260219014335.9061-1-csander@purestorage.com> <bbe35147-af86-4066-8732-c0d786c83df5@samsung.com>
In-Reply-To: <bbe35147-af86-4066-8732-c0d786c83df5@samsung.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 19 Feb 2026 09:03:25 -0800
X-Gm-Features: AaiRm514HVDr43F6uGOoNr91TzPyJVfVDvc5lu9SfKCR-pgqvUyhUK65XwoRlkA
Message-ID: <CADUfDZopEPJ5C37iTRWYmsJq5u=uVBXm1EbR1GsWm=2QtjA2fg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12337-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,samsung.com:email]
X-Rspamd-Queue-Id: A92D8160E94
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 5:30=E2=80=AFAM Kanchan Joshi <joshi.k@samsung.com>=
 wrote:
>
> On 2/19/2026 7:13 AM, Caleb Sander Mateos wrote:
> > Currently, creating an io_uring with IORING_SETUP_IOPOLL requires all
> > requests issued to it to support iopoll. This prevents, for example,
> > using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> > zero-copy buffer registrations are performed using a uring_cmd. There's
> > no technical reason why these non-iopoll uring_cmds can't be supported.
> > They will either complete synchronously or via an external mechanism
> > that calls io_uring_cmd_done(), so they don't need to be polled.
> >
> > Allow uring_cmd requests to be issued to IORING_SETUP_IOPOLL io_urings
> > even if their files don't implement ->uring_cmd_iopoll().
>
> For a moment I felt that series is going to change the user-facing
> behavior of IORING_SETUP_IOPOLL and therefore might require a
> documentation update [1].
> But the change is limited to uring-cmd and that too for the files that
> don't implement ->uring_cmd_iopoll().

Yes, in principle it should be possible to allow individual I/Os to
opt out of iopoll. I mentioned that as a future possibility in patch 1
("io_uring: add REQ_F_IOPOLL"). I'm wary of using up the last bit in
io_uring_sqe's 8-bit flags field for this possibly niche usecase. I
think it would probably make more sense to use an opcode-specific flag
field, e.g. rw_flags or attr_type_mask for read/write requests and
uring_cmd_flags for uring_cmd. Any opcodes that don't support iopoll
would implicitly opt out of it. I'd like to get some feedback about
the UAPI for opting out of iopoll and whether it even seems useful,
which is why I'm deferring it from this series.

>
>
> [1] The man page for IORING_SETUP_IOPOLL: "it is illegal to mix and
> match polled and non-polled I/O on an io_uring".

Good observation. I can definitely send a liburing PR to update the
man page if this series lands. FWIW, there are already several opcodes
allowed on IORING_SETUP_IOPOLL io_urings (IORING_OP_NOP,
IORING_OP_FILES_UPDATE, IORING_OP_MSG_RING, etc.) that don't actually
implement iopoll semantics. Basically any request that completes
synchronously is fine, but mixing iopoll requests with epoll-style
"poll" requests may be problematic.

Thanks,
Caleb

