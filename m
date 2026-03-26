Return-Path: <io-uring+bounces-12869-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2LxjDASKxWlc+wQAu9opvQ
	(envelope-from <io-uring+bounces-12869-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:33:24 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C65A733AF93
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 20:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 1131630266F2
	for <lists+io-uring@lfdr.de>; Thu, 26 Mar 2026 19:33:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF952DEA9D;
	Thu, 26 Mar 2026 19:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LkdroYlw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4913B346E47
	for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774553600; cv=pass; b=CryWMHD9THCqKEMK6taPSLAv02VNfxsConFd4UAOQmbpuVDjlnbRKiSC6f8JJKcgMrtB+veoLvYBu1H716AlehGttPHkvZDNgPe3QjZ4SWKdDmsKw7oYSJN5qG79osNHNt4/PaT77990Ij9obiFvud1C0B2W/33T7NalptETBLQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774553600; c=relaxed/simple;
	bh=XGIkITr18YRht3P80h9kmZoQ7SS32tZiWRhyFaczp1Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=InURKtGJHzg3xvcwga6anxEkBkk/keh1KM4Mt/2lifGLNYNWYEfxYnpkSwAOhRPghzWbLIUEIApklCqZFD+Wl/wG9Sr70qiS/vWInitjHEm4RVqgQilI5Q84LB4cfEJDQNOIDlKn7GnJf2vL9TILIPEaUag4sh/9WWg3RTszE/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LkdroYlw; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-66b0dc690bcso227a12.1
        for <io-uring@vger.kernel.org>; Thu, 26 Mar 2026 12:33:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774553597; cv=none;
        d=google.com; s=arc-20240605;
        b=JR9QX4mJ0mZSM8uhi1+uKozHvPZ3jcU/WQy08giEZeXp3Qe6GkZsX1DTWthXBVN0AM
         9q6UWuwd5XGzsiWHoBjb6s5GyxX1P+LXVvsqZp2/KGCF01nHQQxFqLqnFmxDaDEsehkD
         EEFLggr2U7dyQSTbV/Qse/OSWeu3kGOyY/dkWBNvPb8DUeO7m3BDllpLrcDyJmnx3A7k
         i5x387dpNPBxU2s32U8QBU2TQIhgNyiCALINXGjyxzx1ztXRUPkl0nbs4ZBewBWfHgmI
         LltsKG8aK0vDOyTHJyK2DIZuzkZouXc7kWsnpK9gSdRWqO2UlXr10O7Q/rohBr/rMbci
         rEkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=i0YYIrvHnBTLeQ6iT3Vhfn1kaGtvbxQ898sn+jDwG2o=;
        fh=EJEwg+zNn/WRyxiSgX148meMrg3p9ifn+a79wg0Ayls=;
        b=XlSaJfVm38BDI75HrcZBhfP21jv12DSeBI8IErrSOBl6Z995FhQIVZyHm5jD2o+mRB
         W7Nvzxd4KP5lxsszSpS+U6vI4wBhBYcCKl3JoIFjkJYjUMjcNmfOB5Uy14zW3EN5iUU2
         7Omi7LkMfC9d+b+Yn9DPqtoMElA8cFdLDRrvjhMbX1fi2SG7BLrHOGSAy1ByTzVvPVph
         OzkVvyY1IQv5y4r3TjN9eLyen6lqMirW24qxqp7eVRm/ahkEDptpDmBCZ/OIDXri8Z8E
         3iyOvyDIQHmQ/qrLJfYDnQwmwIqje6TVDQtlBTsfiZKcoNQm0+/sDT1buhIN1xUoXG6X
         l8xQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774553597; x=1775158397; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0YYIrvHnBTLeQ6iT3Vhfn1kaGtvbxQ898sn+jDwG2o=;
        b=LkdroYlwmNyNc112hm8cLn0jT9UjNXFknsKEqf1hPo6WBik/MI8l9J89RQtzX2M795
         DU8oTOXxVeXejWRfPk7q09thkC26WRGEIH/x/EHd6VFdvuWPNJpKLc8/1ruvQiPjS8+r
         XLo+umGYiN0ihUSSEMSIIYY1ykesNxWDAJuR+7H/566eAibZvJrZKgpekOXyaIrapa/f
         3xrbufMymx6CYMvEHrI68V5SiL9UIyxZwaAnVzD3CX7W6fa1DKcmBbjsoRP/h6zCiihP
         T/3iYZiUzRHNrr5ClY5o7T/VcqLdw+5/lhX1sULydiyaAGAa1AOSolPODFdYkUCPDyoX
         NLuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774553597; x=1775158397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=i0YYIrvHnBTLeQ6iT3Vhfn1kaGtvbxQ898sn+jDwG2o=;
        b=nuobpcmoxASkQHwFs1ATKQKHG8ficmXzHAmhuiuw3umPBntYXKZEuR5yhP7teFIicE
         dpGAFEzUeahHqomUU0JTEXmRq9yizY/DoohusnGzc8Acad9htHbs2odtBazZjhJ2JQvG
         gV2ivQ12+u6dyn50ZIlCsRNxvBpYT2nSsBiBYCzpq2pBfAWoRpniYvBWQn+blRJOnMFN
         0K8C5wtSE3NsohPBMDlEyU6YLXa7/XbCWZOF9N/3RHS/5ujUaWvCnNNCdFRrKJjWhe1H
         D6un8TejvpPbvPS+iW/SxcgSJDW2Lhf7qGoOcPlsyn33IXs1bDZxtZ7Z0q80py/k8eT6
         OCbQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdkUwenNSP56t3fUQh81h2IBKS0AMXe/YJhVv0on+8C82v0V8TgsVDR8VpRCKhi9VykTSrECiqHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyi9L0ng/jdytTDTOcXjna1OgF0BeshvpugBnv1x1FLDkM6+i9L
	JMoDLXtbyJcAZW5YNHwpxozT7RMi8JpeeCxdLAp5dG0NrffkjdsGwuzOSeqy4gV6x3t4WLD/BLd
	RFwhQELpFYGYJGeJVmtY1dHZ/2C1B6inOa6z2fDBu
X-Gm-Gg: ATEYQzwPwggpTEtj4wv2onQot4QyZq1dbbQTvrMCzyGbBKFYLNse6ync6x0FnfUb5Ts
	r6P+kpOpbh91ZA70kc4GDkDqRH9ctzrRoCjuEYsnUMUsMbUTkL5MMSKtT7I90nRsNSNFrIR/23A
	XV2L9Vhgqx8asukW0wxAzEh81irxdK7+KGV7PgpDQalr8SrSqCgVLfJdD7qaIE5x2G+vP41cnIB
	UWtZFTE0N9klV0CJOMP8TH09GTpTyCvqYUCO7cjQ67Rw7fmXd72jcBwKzTscYs8RFFNLtopPRCA
	el+GsaDRWq4AZc9Yy4Xt3RrwYWmlox/RwAFt
X-Received: by 2002:a05:6402:3054:20b0:665:d39:4b18 with SMTP id
 4fb4d7f45d1cf-66b19dbc821mr9214a12.8.1774553597067; Thu, 26 Mar 2026 12:33:17
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
In-Reply-To: <20260306003224.3620942-1-joannelkoong@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 26 Mar 2026 20:32:40 +0100
X-Gm-Features: AQROBzAqizh2z5m9_5qLH-WZQAEv4v5co6vK-W8Njl6U5WEXvbdoBACM9aVLgiU
Message-ID: <CAG48ez0H_Z-NQvfOeczECz_sO=MzVDvu+8m+msB55rcAPfQOgQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/8] io_uring: add kernel-managed buffer rings
To: Joanne Koong <joannelkoong@gmail.com>
Cc: axboe@kernel.dk, hch@infradead.org, asml.silence@gmail.com, 
	bernd@bsbernd.com, csander@purestorage.com, krisman@suse.de, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12869-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jannh@google.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C65A733AF93
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri, Mar 6, 2026 at 1:32=E2=80=AFAM Joanne Koong <joannelkoong@gmail.com=
> wrote:
> Currently, io_uring buffer rings require the application to allocate and
> manage the backing buffers. This series introduces buffer rings where the
> kernel allocates and manages the buffers on behalf of the application. Fr=
om
> the uapi side, this goes through the pbuf ring interface, through the
> IOU_PBUF_RING_KERNEL_MANAGED flag.
>
> There was a long discussion with Pavel on v1 [1] regarding the design. Th=
e
> alternatives were to have the buffers allocated and registered through a
> memory region or through the registered buffers interface and have fuse
> implement ring buffer logic internally outside of io-uring. However, beca=
use
> the buffers need to be contiguous for DMA and some high-performance fuse
> servers may need non-fuse io-uring requests to use the buffer ring direct=
ly,
> v3 keeps the design.

I'm looking at the next-20260324 tree and trying to understand what
happens if normal userspace (without FUSE) tries to use
IOBL_KERNEL_MANAGED.

For a buffer list with IOBL_KERNEL_MANAGED, io_ring_buffer_select()
will write a kernel pointer into sel.kaddr, but nothing in this series
seems to ever read out of sel.kaddr; that only happens in
fuse_uring_select_buffer() in the FUSE series
(https://github.com/joannekoong/linux/commit/fae19be22ab629b1301f37f2a942d5=
d84b45cc5c).

Instead, looking at the reverse call graph of io_ring_buffer_select():

io_ring_buffer_select
  io_buffer_select
    io_recvmsg
    io_recv_buf_select
    __io_import_rw_buffer

 - io_recvmsg() passes sel.addr into iov_iter_ubuf(), which creates an ITER=
_UBUF
 - io_recv_buf_select() passes sel.addr into import_ubuf(), which does
an access_ok() check before creating an ITER_UBUF
 - __io_import_rw_buffer() also passes sel.addr into import_ubuf()

I think that means io_recv_buf_select() and __io_import_rw_buffer()
will first access the union through the wrong member, then fail on
access_ok().
io_recvmsg() will create an ITER_UBUF pointing to kernel memory (which
AFAIK isn't supposed to happen?), which I think will then cause a
later failure when you actually try to access the iterator (because
copy_to_user_iter() checks access_ok()).

Am I missing something that prevents normal io_uring operations from
grabbing IOBL_KERNEL_MANAGED buffers and accessing the wrong union
member?

