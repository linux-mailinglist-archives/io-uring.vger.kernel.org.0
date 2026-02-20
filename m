Return-Path: <io-uring+bounces-12353-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aDtnMVaKmGlwJgMAu9opvQ
	(envelope-from <io-uring+bounces-12353-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 17:22:46 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30C091694D9
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 17:22:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D6154301AA5E
	for <lists+io-uring@lfdr.de>; Fri, 20 Feb 2026 16:22:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6402ECEA5;
	Fri, 20 Feb 2026 16:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="E1PX9Yke"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E742EDD7D
	for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 16:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771604563; cv=pass; b=u9BjKo0FZknwV7tvFVD9dH5yumUctQz6O49sLyNQPWnfatJe1cV7bWKNrc3umHIBJ5v9SpSkWqurmYK8CUxheb58wqbKqKRke7aTwPQPxcynDeBkaDxKhii7Hjb5N9PMWjGcwMICCpfS3npA1MbAHA3ClBtWRsOZfw0DH2ah7II=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771604563; c=relaxed/simple;
	bh=CEpG0Asu+in3PXSWcL0isDZX5KtRi550kSpC3TdsTDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gxTeVRp8WCDisrmXphviOSwe7Y+ONlPSqIhIoc4QunmMMR8gE3eLNqr+fEYowdPyEjZlnYYuc39cOFqXtK3CPHu/BOcQhdDOsCcP82obvhyAnggE3zzXm79+vi8SE9dbHFyYqJ1b8hTOIzd7dOnHjCk7c3DlXgX1cy+vznKsjYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=E1PX9Yke; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b8f7f7a1b80so11911766b.2
        for <io-uring@vger.kernel.org>; Fri, 20 Feb 2026 08:22:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771604560; cv=none;
        d=google.com; s=arc-20240605;
        b=W973I0Z7KkK0sE+E+MZ086w4K9fQL2XeoF1737Z0HBt8Gnv+VOaLQ179wX3wG44wZb
         5m8RqAfYtDS2dYcMt53LYoal/2iFwmOumBt86jFf9YXWswQps5icHx/2s9D4IH6/S2AX
         8h1Z33xT0c20EwdcwNx8W13qSdrK082QgqGR7Y2rBZ4DyOE07ZgfZOiwxeR94wPvOZYg
         iapKffv+QA/6NQnt75Rx5KbWRGMnF0YXS4WNsM+O7tmo/UCcD2butMn2lJBD/lVCjF+B
         7A/m/dy+2qF1R740NHOSmTMk7a8oLc/rK7KQFlmJbqRJoUfB4Px3eXV54TQam/Noq0bj
         2Sew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CEpG0Asu+in3PXSWcL0isDZX5KtRi550kSpC3TdsTDE=;
        fh=YGn2rJ+zTBhETFlv0z72PdhTjGB1KFuQxhgMYZ68q30=;
        b=ikDfkUOIQUV75zWxFye8YLtNAejIa6HlQTvRS4sOzk9M7HF1uoCWLd7IeaEAMLPlbn
         Y/x70ROVxYvdy6jVQK8+CU6yemPVHttv7LcJzYWR+AxtBgJlqKVTRmJmZtwU8diA6dER
         NP5WxJhHJT99blIxCOsSq4hCxkEtHYTegXd7eFX0g25Pmw2NMGWMem8Zd087xS7YduuT
         9lpNRGTedOzkpEYmlJpJqvbIXfzUTpSMo9W5V4vt6q8pkNefwUJf7NYghUUitzBZmgl0
         aNZlnQv2J2rxbA+PvAay/HVUSOnulcbY9d4W0YI2sY++xiZwfrnss9jhK2H5iKQ3MRTX
         Mgjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771604560; x=1772209360; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEpG0Asu+in3PXSWcL0isDZX5KtRi550kSpC3TdsTDE=;
        b=E1PX9YkegCbvNFz77+CxX8P7ioFYdP21EXBCag1ubovAkdYsndpm5VNqqDPKtk4QNL
         kh1S+Fmzo3xq47O3A3tDvt3RGIZMPMPanqmNeOzTNI9suDmjRtb092Dk6opHK/euSzNE
         bcgkVObwHn/ohA/uzgmuym084Ya/DEVC9MXDt1MNfd2PE2gjouSZfayAlTLbJad5r6aS
         HCf8raZ2a2dlWbDgZOJulyVOi2bUbx4MHUCfitxdMzCEfPJKRk1J4bZKcTiTa+3KRBWe
         +EPTeVhhTf3+finJfcaCnyk54H80MZrLQKDjcYUUYarbDRthHO3Jnv8gOmHY/kDvZ475
         EfgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771604560; x=1772209360;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CEpG0Asu+in3PXSWcL0isDZX5KtRi550kSpC3TdsTDE=;
        b=quVuh92fhG9oUgFeX36042dF/qEst3msi3A4Q/xWcmUzcmnQ/sPNBlHd9HHSvYVFEp
         gk78xo8r6dwuaFP4rX4XfTuOvejvv5sqtSy5aNCbyu/tffJNMg7lcdCSiMz50U1VdUOp
         4Mnn52KtPGxiUpZlnbO/Ra/OImoYLj5X7Nw103t++UeY3spTQnvlSs+aodPWEdsypOp2
         j5mu3SCa8ZtriXBolbTTaFp8kCx01mBqGqcpv4lgbe/tjve35EgDexGIYFTAa1SuDuh0
         Zb0r81m5Y5Wf2O0AlPy6wqDWE5WIB20SW218TW30Q54C3GtpL/vTiWgYlqXdETnvVyLv
         XrPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVltCVMIJTL6y/WDFDRUqSilf4q8IMIhC7T1flteg2GY5tQbJToh+oQCdzKbiKiXUOgzBlKC0enWg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqkZhhDI1nuX4wD8B38wM0dHeiPh76ihsWyBoBZqJWdzQd97BT
	TVae6y1mx8s/Hc+l+OdW39UZxqHzBWLfDMylkQdpwEVldbUoxZP776WVzOs3dSCy6XBONzely8C
	nXT08BmFJ8rXSbmjkUGaz+OavB6cTTuld4zB/ckScnQ==
X-Gm-Gg: AZuq6aJXpyDwu5Ru6GUmvke8hdHBSTeBBtelsD+8hzdmwsMkfmaiMqzlD6ZVCofQMA2
	ofcqk33Pxga/HRkX1GgcWHYR2AMpl/0F0xKnBYRvQACzYH6reNw70CzzqoFBTseZ0TmKGDHn5ET
	OhRbzd0BE8ebK1VCPnzWBZ/KpubEWDkrLmnAhMQUddXJAZtCQaUFoMmiFNrgRQ3jbS/kwmT9hOl
	/oIMWLwUhSvXUBlRqybG3KHimADJtvsomb42OIGMN70lSW+FEVOPeWdCN03XSVu7NTjL63/axiy
	K4yFMOEnbHDtAOtOBbg=
X-Received: by 2002:a17:906:ee87:b0:b8d:e858:dee5 with SMTP id
 a640c23a62f3a-b9081b6dcd5mr906366b.5.1771604560283; Fri, 20 Feb 2026 08:22:40
 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219172228.429479-1-csander@purestorage.com>
 <aZhuwOku9lFe33UM@fedora> <CADUfDZr3ksmd=ZZOhU4RJsqEzbxBHnDPCtOQXJ5ft=X7irWvPQ@mail.gmail.com>
 <aZiHlp8nOPgQFGMq@fedora>
In-Reply-To: <aZiHlp8nOPgQFGMq@fedora>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 20 Feb 2026 08:22:29 -0800
X-Gm-Features: AaiRm513RQKxAb9S4lN47njXOP1hMUP9KvVkWx2uUV-jY4xIGUbozyhkjbTIMts
Message-ID: <CADUfDZoxW0m4nptfNYqmqFCdTj6zSaYOk1vYSKU5JztkjEjD=g@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] io_uring/uring_cmd: allow non-iopoll cmds with IORING_SETUP_IOPOLL
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Anuj gupta <anuj1072538@gmail.com>, 
	Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[kernel.dk,lst.de,kernel.org,grimberg.me,vger.kernel.org,lists.infradead.org,gmail.com,samsung.com];
	TAGGED_FROM(0.00)[bounces-12353-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[purestorage.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[purestorage.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 30C091694D9
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 8:11=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> On Fri, Feb 20, 2026 at 07:55:33AM -0800, Caleb Sander Mateos wrote:
> > On Fri, Feb 20, 2026 at 6:25=E2=80=AFAM Ming Lei <ming.lei@redhat.com> =
wrote:
> > >
> > > On Thu, Feb 19, 2026 at 10:22:23AM -0700, Caleb Sander Mateos wrote:
> > > > Currently, creating an io_uring with IORING_SETUP_IOPOLL requires a=
ll
> > > > requests issued to it to support iopoll. This prevents, for example=
,
> > > > using ublk zero-copy together with IORING_SETUP_IOPOLL, as ublk
> > > > zero-copy buffer registrations are performed using a uring_cmd. The=
re's
> > > > no technical reason why these non-iopoll uring_cmds can't be suppor=
ted.
> > > > They will either complete synchronously or via an external mechanis=
m
> > > > that calls io_uring_cmd_done(), so they don't need to be polled.
> > >
> > > For sync uring command, it is fine to support for IOPOLL.
> > >
> > > However, there are async uring command, which may be completed in irq
> > > context, or in multishot way, at least the later isn't supported in
> > > io_do_iopoll() yet.
> >
> > Can you describe the issues you envision in more detail?
>
> Basically IOPOLL doesn't support multishot request yet.
>
> For example, when io_uring_mshot_cmd_post_cqe() is called and new cqe is
> queued, it can't be found from io_iopoll_check()<-io_uring_enter(IORING_E=
NTER_GETEVENTS).

I don't think that's a new issue, though. You're right that
io_uring_mshot_cmd_post_cqe() assumes a non-REQ_F_IOPOLL request, so
it's up to the ->uring_cmd() implementation to ensure that (which ublk
already does). Since ublk's struct file_operations don't provide
->uring_cmd_iopoll(), any ublk uring_cmds issued to an
IORING_SETUP_IOPOLL io_uring won't have REQ_F_IOPOLL set, so
io_uring_mshot_cmd_post_cqe() should work just fine.

Best,
Caleb

