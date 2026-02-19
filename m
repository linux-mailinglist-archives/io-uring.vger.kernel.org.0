Return-Path: <io-uring+bounces-12336-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0JgUCu00l2kCvwIAu9opvQ
	(envelope-from <io-uring+bounces-12336-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:06:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B3051607C8
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 17:06:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A72EE300F9F0
	for <lists+io-uring@lfdr.de>; Thu, 19 Feb 2026 16:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36175344050;
	Thu, 19 Feb 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VgOD0voY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0352EB860
	for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771517162; cv=pass; b=cQOvK/UNsVSYzBCv/3lYPD3e41ibVmpXRi4CvYb0ktDJL6Njxl7vlJSO48V27W7chTv/8O1+PtE8VlOFZoa+CiYC8uVBOyMh2aGN6eIBCoMOxQE3VXGmLx73lnvi5xmoOqkmV5XQKRaca3IByVzS3jP70sT9V5IsqXwJkhaIh8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771517162; c=relaxed/simple;
	bh=fhrE1fQlHc7+MQv3NZiVraDAsjEm3lUdm1DpvrD2p3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pgZQEnrtzFID7Dkk+gtB7Uwes4gR5JHxUyRZDZPmTMfVZKaLAS8YUdnaA4458wRWKgPNz88jORqfgCpZBVw5flotmrfpJISJKLVaGYwsT+oMgdov59Ojo8O+JlY5nslh5cRlYbTW73Jzhc3TVfvzRVLll1z8y2vqA0YKXCKhiVA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VgOD0voY; arc=pass smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-65a1faf828bso63650a12.2
        for <io-uring@vger.kernel.org>; Thu, 19 Feb 2026 08:06:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771517159; cv=none;
        d=google.com; s=arc-20240605;
        b=E31r/UrVXQWAFAorlgfSrlzQqPhRYTelbkiZGWG3/4gAYEsSpJUcM8rd8bAzMMkqbf
         I4eqmy6gQZu/Io+6mwgPsZc0XQOsGicRQyq+RqMWT+27+SzmVvY2dhxohoGg/NLIRYVw
         K4vjUPWB+KrLo5iYKXKUVA5/nRiV+ap2P1RH9sxB/+XzaSm5uBhWzqbLkEhd5FCqDbG+
         3iz46FzzWIB9yXJu50H1KX8IA6Zlyg/6dhpKUIwhhggl7jLJEHnSupM/36krN8OnjdEK
         DkfE0f7Eu02sew4Zt99FS9SPWmMznobxxgwB8KUduxmoizEWu/L1zMVLd9AubW4Q/stA
         ww2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/x9hZC8EplBXWTWBtGo8KWBQFeqJeKq9WTJDuTB04dM=;
        fh=6peGBrKnyTl3Q8yQfniYSYR4Jxo7oc34ywwjdROBbHA=;
        b=ZKMTXFuJog5UtYpSUPtgo1/dx226Nlu+vVvu1fIJma42Uv/+oRtViCyqE08U8swB9o
         oyLhFH+UYHSA20OtWrppTmbGVR07jTSAVLRqNX+3ReNtzOAKE+Dyma+lREIx4IqN9E2X
         mr6PSJ1yvmT37NtM6icBrDvakj7jlq2TmHRi1genM2DrtRrUydeyhoMsMVmxGyJuZKPG
         iLIZL09oqUKQ9RfMrV5/Qw7y2I6PKSztG7LDHfYIc/jSdOB+GbKU0j1HUPQj0FcG1G3e
         I5GVHrFmAdc9OyIamy04GXMKWB60IvyXavmwvjErHFWqVrKCfSdY2EashHmoUv+9NxU5
         LhDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1771517159; x=1772121959; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/x9hZC8EplBXWTWBtGo8KWBQFeqJeKq9WTJDuTB04dM=;
        b=VgOD0voYymy9JVqxH5pbEI2rH+ITKRBGi6ha4Us7rdlA1PNd86rEWkb2kJo/R0KedR
         K5EIl4gd8B0xS23szNiDXtTJKMG1AinkV6ZlYSG/vAZvs6sdaWtcauXeqx/pDb8REjLY
         Of9bax52uzCUiYe4pi56DxaAlp60oBh1UzdEn4h9QziMLB1Sv5ps6pC7pPAzd5a6nikq
         OedAgpmlPhLCfxp+jX+YvmuzJ0SYMEKGLeOxMbx8Fw0+g22LZ/wumjQ1Bh7V4oJwupQG
         wUsubTThOIVl7/NvTU0XLnacwJ7KN4VyxGEKpL7uM7UZDjm/98cq3DFf7bSieLf2Niv1
         1RKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771517159; x=1772121959;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/x9hZC8EplBXWTWBtGo8KWBQFeqJeKq9WTJDuTB04dM=;
        b=kB/uFZvuWnNHWTahCs0ho8YwVdpj2VOThBv1GEk+rOx+Pb9qcVAjsQSX+SeXi7ZMX4
         XtXkRjogvtwsUVlFfpWGWx5sXs3cbi3TWaC5rFqt5C1N0zu6qsRO1O7HYFNkIbGj+bOA
         7xwYQIK7zsChVsNnLAkLoeA9URzke16CZw7Y3nHfd5Jc6f6ygYYQ5rn8fPO9w1yIwQax
         95xWNPobM+eqvBkUy7mtV8Ddg7l6Bw/wSMfSIpDRj0p3Ylj07xg4hY304wkAnoymlIZy
         7YXLavyBcmaWyC1HrbY/E1jF7nF6v65VqKxO+vM3c/3gQOwrWXlk9yXuDBWJrLT/l/yP
         GkjA==
X-Forwarded-Encrypted: i=1; AJvYcCWHVbT7kC7bELPvlJBCkwMCfjumDY2Uir3CmtOYhgvglwOPXNCHP7AszlGz7Ssb6sqsWm7Oqc4mBg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYhDm/7erzAliS1pB0o0EZ8j7t4DhCdyVhbLEDfG3kbqTkSWzt
	1WXPRliI3QZOcRrTasdtFPb/dmn2kl3eL+ofXzuD7Z1WYmiLaZKzMDn6dCVYm+NwdzQnY7CJAUt
	endUTEuS9Wl8uZ5USUp1/UR7ow7t6keJ1LWktJuYldg==
X-Gm-Gg: AZuq6aKlAXKpEip6ckNj9nuQu3r1x3X8emq0wQ8M30atLUNMgbOgbGatSevXa4zTcSn
	gsn55j95mMuf3vKGMBW/TYQ4Fuf6Mp0cnIqF/Vg4oWFDur6c9lwpqjlzWpmIpy7zlBSX5bR47L8
	toLI63T9HQx6jePWh5zWX3M0+wUmE+4wXp9/7EOd6kPNHod02GG9Xnl2chxrtFPN+ixE97yIN/l
	hN3wHakuPGxqhDJCm47TRhkerC/u9otk2RYKQWCxWIfFHr6HTuT7O9HU4sKPRKhZBn1wu6ts1KQ
	XjVxL1vl
X-Received: by 2002:a05:6402:2808:b0:65a:3c0b:85e7 with SMTP id
 4fb4d7f45d1cf-65bad14f893mr6872126a12.6.1771517158805; Thu, 19 Feb 2026
 08:05:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260219014335.9061-1-csander@purestorage.com>
 <20260219014335.9061-2-csander@purestorage.com> <CACzX3AvpBv_vM5DNFmxBcMoCogC4HK1e0c58PA0kiBQ1wMacow@mail.gmail.com>
In-Reply-To: <CACzX3AvpBv_vM5DNFmxBcMoCogC4HK1e0c58PA0kiBQ1wMacow@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 19 Feb 2026 08:05:47 -0800
X-Gm-Features: AaiRm52e4AXuAZfVzFRiojhXAflRftulDVyOfdFRPY4BmS-UR6hLrd3nWi17ZCE
Message-ID: <CADUfDZrk1Ro+VmaTDcbsUwQiL8EHhqbFbzHTrc5s0AJxbwdqTQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] io_uring: add REQ_F_IOPOLL
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@kernel.org>, 
	Sagi Grimberg <sagi@grimberg.me>, io-uring@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12336-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[purestorage.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid]
X-Rspamd-Queue-Id: 6B3051607C8
X-Rspamd-Action: no action

On Thu, Feb 19, 2026 at 4:39=E2=80=AFAM Anuj gupta <anuj1072538@gmail.com> =
wrote:
>
> >         REQ_F_HAS_METADATA_BIT,
> >         REQ_F_IMPORT_BUFFER_BIT,
> >         REQ_F_SQE_COPIED_BIT,
> > +       REW_F_IOPOLL_BIT,
> >
> nit: should this be REQ_F_IOPOLL_BIT for naming consistency with the
> other REQ_F_*_BIT entries? Otherwise this looks good.

Absolutely, sorry for the typo.

Thanks,
Caleb

