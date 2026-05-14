Return-Path: <io-uring+bounces-13323-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gN1fC9KtBWrkZgIAu9opvQ
	(envelope-from <io-uring+bounces-13323-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:11:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 52996540D23
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 13:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 201FD301DECB
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2026 11:11:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304FD388E5E;
	Thu, 14 May 2026 11:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ej6mjaZi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E56D357D03
	for <io-uring@vger.kernel.org>; Thu, 14 May 2026 11:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778757070; cv=pass; b=U/ALTCiRfcUCvtAXcfAqgyFzcfaSxcUq2qzyqlqkX+5O5F+sdkml7syuKugl7rF2nAaslDK9a9vhYSwz1DJl7ok+/ps0TwZtAiEoyWUl3JHD5wKuSLBFE3tir5ylJ2jkPHabITAy07WQKYvZTrQ4g2IpfZ/jwX9cEy/IOWKzxHU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778757070; c=relaxed/simple;
	bh=W+Yrzi4ldXosFMjMSjWOx1tcyqkkT4kutNq46SnE3EY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=THAc0wId9EWwYGLMsI/wYKAjQ2Zr6Z+DN4YRPRuNH3+YhG2lmGbCmWF4M9/0wJbZ1b1fEk3mMcoNcza1x27UgUaDZLWOWDdjz2nIVpw4MFcy69xXE7nmfIw5LfuZpUhW1QA2u9KBEZtDuRB2Im45+ITgYcDQWTujWg5QkFN11Yo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ej6mjaZi; arc=pass smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-488b150559bso61361625e9.1
        for <io-uring@vger.kernel.org>; Thu, 14 May 2026 04:11:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778757067; cv=none;
        d=google.com; s=arc-20240605;
        b=XrrH1jQy0ZoWLoeUmvfPnSaHkfAra47/XofLA9LM5g4xHvUn+VEWasOU3UlSvwYJfb
         sLA7yJsx/gBp0DYTmQceV+QQvEIy3WI6jmIzlguJkvpjVrQ3BtLYCX0zznuKdzL83KGv
         bDr93UknJfxA0Y1YXRgD3IfENPQUVg7hu9z4R/6TrCYLZv7SrYBhMjWU8o9aCM5IWM1h
         dOdVHMT7syXUlDJ5SPgB7snHzhfseLxbTsIqU3ODdeudQPQqZE0/jw9pEVIwu8gzKwE5
         wLXc4DhsV4qeXeXNHKQml/EBC2WMdu042WkAj4F65cfebXRneJPbJFrrko1e/t4DCv+i
         Fodw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2z1oGSnmN7pjgKaZMar1ikzwLFdCPPhRg1amA8O9xQU=;
        fh=yH0xKWXLua1AIUy8cl6QMwfu9D4VGY8b6y2eWq905AY=;
        b=aSZyWFdakTL4hLpkPz5DqEn+jPfJYiLkBiiMipXx1sf+e7UeOYotTj5TfQXnpDpIV7
         4TSZz3P6otLvhAvpXouY98jaH1DW2vZpZ8KlDRFAFXxJw2gz4rKZWZnpLFwdOXa7AA6L
         sKLAWuNF6DKcRDPvA37LZKBbyIlxrclYjDEnpX3QczKxo4do+cmcvIOD1a4XlKXAEN0J
         ipSJNE+UrCQ7NOrvnyuI1fxRgxf0JqqvuZnAfZBGxLMyF5diNI8hSQoW18kK9Lx9a97n
         Ryq+/kDXuq8YwI167OCc/+cvUqIP7dU02YEUQU5bt6NoTothjXC8k0vO7KGI48p75ziW
         1HHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778757067; x=1779361867; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2z1oGSnmN7pjgKaZMar1ikzwLFdCPPhRg1amA8O9xQU=;
        b=Ej6mjaZiym08AOdpMHVAt92I2S3+ty0IOY2OAWl5RgbZngrCEXLnv3xxd7Gl9Jiq0M
         cO/jxjD95AocAaavh5XnWD5zxfYy12cNZ6evt02TBlRoz3fOwRFJhWf9IvrGWt6rgKUt
         34sIdOgATwwNY+jthmiz+6thm53A/wew3HdjzcQZ803ZhhKFyI4zWfqCzcWPPkcN2hN7
         JAI4i5GgGcMyKWb9C4glibPVQtUtX6obfQhnh+J9dClCbjectD6H9dOdEzJ15Se+3J8s
         TyuygdrD+NufpxCcbyLqi9Y+0Kql+S1qCfS4zFisAgFq4bYKEwzq4Rv8nWNX12wN36rO
         CW+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778757067; x=1779361867;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2z1oGSnmN7pjgKaZMar1ikzwLFdCPPhRg1amA8O9xQU=;
        b=eml+Y9IYXve1Z4G26gc1ZOleb6a6sjS+tG78lE8mTajL539Igff1aB5AEyhORqaPah
         p0xEB1zJ74Wd7gzMRDgchHEJ+6TlLFijcm+uuWcHLT1TVEe4uuHSzgaNuKzdlIolEGaA
         +IdZzv5ZSJK68pVx/MilmPIDD0v2G/YS0lJ/CzSX6sRmhb110AAo8W7KQfKmHT9WgNcp
         eriZEBvm2X1VBKV9Kt8A39kOM/AF2wuOw1rI7Bf5U0zjbJBu4n9sRX1kazje4eU3pSKT
         f4DPaJq0X6rpFguTa83aCq2lXHocv0dA3jORnTGg7LxGT4E4Hnz3fijVm1/tcFlIfJj3
         jubw==
X-Gm-Message-State: AOJu0YzcdNHQCIKEkWqWCbdC9oZb820nvkEuw29RZORTTxV5muRwaFrG
	6eVOdnqkJ9VCygA4ZVlp+8zaHLf7CpQQb2Gja7R24Vk58SgZQbuy4L6fek9w0E0/3MTDwaPW/9u
	sursmv4j0xkA8GadJTLOxFbwSg6q8Cck=
X-Gm-Gg: Acq92OEwjWsA6x8pwQUOnrtHaZOSg54vunYrMxU2/7slPkOW+7g1MoxQ2KGyUihct/i
	03PGJZFShN6F8fDfhLljkmZdIwuzIK6Z31UvGL3w2IaN2gx/78Kdn5uAUBoSZgrr5b2jqKCkYnq
	J5+TiOtdt3J/EoDtrJAxRrFKSCWU6DXi0TK/N4OBBkJROcEmorxfLxQ9RN+UJ+rxPpVQDxrWn7B
	8TH++ctClJbz2OsiAtxC3lOesyIjTU5eYQhj//pZzhNjTMaRTPRiSxXhsfoC5ElOGrLwYMgIQ9J
	9DvxLLBbewFzKak6fKfaFW3+dhWKGxD7KxB0ivfSXCghy4e953dp
X-Received: by 2002:a05:600d:b:b0:48f:e230:2a1c with SMTP id
 5b1f17b1804b1-48fe2302af0mr6730245e9.31.1778757066741; Thu, 14 May 2026
 04:11:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260513121040.933053-1-auxcorelabs@gmail.com> <2e18f7c1-6c52-494d-8718-e95e7777e613@kernel.dk>
In-Reply-To: <2e18f7c1-6c52-494d-8718-e95e7777e613@kernel.dk>
From: Shouvik Kar <auxcorelabs@gmail.com>
Date: Thu, 14 May 2026 16:40:55 +0530
X-Gm-Features: AVHnY4LkR6YWGGPhgFozvRBm6WImgvyMk0mxupyQsCvgFg5M1X7XB3kDnEV0S3w
Message-ID: <CABnvZUnvr1D920PvKPtmy95Lrbv+mfAtsAk820WU4v3+KxP3FQ@mail.gmail.com>
Subject: Re: [PATCH liburing] tests: add cBPF filter tests for IORING_OP_CONNECT
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>, 
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 52996540D23
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13323-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[auxcorelabs@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,kernel.dk:email]
X-Rspamd-Action: no action

Sure. Have sent v2 patch  =E2=80=94 added a probe_connect_filter_support()
helper that fork-registers a CONNECT filter once up front and gates
connect subtests behind the result.

Regard,
Shouvik Kar


On Wed, May 13, 2026 at 10:36=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 5/13/26 6:10 AM, Shouvik Kar wrote:
> > Add subtests for IORING_OP_CONNECT to test/cbpf_filter.c, exercising
> > the io_connect_bpf_populate() helper added in the companion kernel
> > patch ("io_uring/net: allow filtering on IORING_OP_CONNECT").
> >
> > Coverage spans both blacklist and whitelist filters for each
> > connect-specific data field (family, v4 address, v6 address, port),
> > plus v4 and v6 subnet matching, and a test for the addr_len guard
> > in io_connect_bpf_populate that prevents stale io_async_msghdr
> > cache from leaking through to the filter on short connects.
>
> If you run this on a kernel that doesn't have your connect changes,
> then you get a lot of:
>
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
> Child: register failed: Message too long
>
> when the test is run. It's important that any liburing test cases
> handles older kernels appropriately. You get some of it for free with
> this test case, as previous tests will have already checked if cbpf
> filters are supported in the first place. But you still need to handle
> the case where cbpf filters are supported by io_uring, yet the kernel
> doesn't support your filter yet.
>
> It should just check for the error on the first case and skip testing
> the rest of them.
>
> --
> Jens Axboe

