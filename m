Return-Path: <io-uring+bounces-13008-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIdCEgf/1mlKKggAu9opvQ
	(envelope-from <io-uring+bounces-13008-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 03:21:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A2A753C533C
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 03:21:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 185613010DA7
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 01:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42A732D5C7A;
	Thu,  9 Apr 2026 01:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="U5nMtlSd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2041A255F2D
	for <io-uring@vger.kernel.org>; Thu,  9 Apr 2026 01:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775697655; cv=none; b=BaVyrBAp7IZuvVaEhR9WhDmYOABPNiovNKfcoSLjMIBgqnt66WJL5xq6p3ubQ4T8+gKo5gjJOcl3COONqMYtzRSYIa78lANHAJqz6u2cxz9Z53j+XnX2O8v7t/eys/D+LmmaUq0dZWR1veeqkrA3f1Dtvk5IYblCtX2KkABRh5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775697655; c=relaxed/simple;
	bh=5XxA5fTwBC6NayOV3TCplxsKPZ+1ZMgEgvtwEae0KhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y5Jlp+Vl7pjSGcm3mjbN0KvFQujptq9Z1s/rORllfzzd2LdG1p7rqXVL1f82k/IGoH8vK/wqL4oOV1vfCec+/APXCu+tdEIXRe+RrZbKl1O96GKz59TeCyjt0EhaMz8DJm7YOFvj7kd8HVj6Iv6Bp32UKGfkLSXRaDIlEHPKqlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=U5nMtlSd; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ab46931cf1so1668175ad.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 18:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775697653; x=1776302453; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IwEecnT2k/SYnlacLAvjP0TbOckn4OHxgNLcKdVMuVc=;
        b=U5nMtlSdKFy0CL6t1xuoVvaRsIsrZ4OSYHlsLiPBuj0ux4J5mMD5d9S6c271bON9iT
         I/ERDWnqiu8oWVNF/p0WjvAx1WD8YuEYkB2engRWNm73O2O2Tj+46nkwpnExszsprI1X
         S48wWWRCvrsZtvhU2IFBC/Yyd7IUhr4/fkqpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775697653; x=1776302453;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IwEecnT2k/SYnlacLAvjP0TbOckn4OHxgNLcKdVMuVc=;
        b=rL9tWuiJ2dkm8p7gUIU9DG/tqCxMRP49DWhfU/Zi0Xfgn6VRehS9gHhfG5UbqJhfdJ
         kxIWLNMikyO82X12mx0QE+SQj0B5+lAUIRMojpedi3kcTpxI8WXsBUp80gortEa+nrtS
         WyIj12CGU1hk3kc9FEADjg053taWPWRusyQtyP23UUSEo5hp8nDs8t7N+s1xUu9vKcZR
         DxQvk8lLPGotlZ2xWATTYKaUn4e/QWckHi+zxJJgmAK2fhiXbIexiZCl+YqZMThsYA6o
         /254mNKhzp8d92i03cqYBsxpCGp07Ywg3oSunCKcDFHEJDYJpBY6UG9CAAt9UEMGFGJS
         O0Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVJlPFxnOEXREq71p9uCHcIUe2fBiy/n2KwRHuP1/ogojmILUbOVfch6dHOxjJ5tEsoo2ppcmtLtA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxU52jj4B8gcvm6fIjYKu51Q2fKcVHwuYiJZi9i3Gk6jPhvKDT7
	CwFRQJBIUKzDqBDMOuN9J8c99B5hdXC1RhPeX+K4XqWdMv1utsQK0IqumtK2yFbzwHg=
X-Gm-Gg: AeBDietx2unJA5k9wMW9KGkRMBRv4lXlcgTrzOddzhSoHucsASc0e1v7TaBptxUh3So
	yXWlZHl18LT7c3Fg8zxZLgShuRU4IxErz71aIg5b6+l+9cY1Z2uZJTw6nQlP/pIXnuZWwstCAAl
	z4gc0VOwEa2bGQ/gf/gUka0fRHS9NZBEv3k1X2yQdV7+72bBORMCk8295vAQS7hTScWVum7cpec
	D+nGrTEupLiyXQlDIVUKHEu6letHHZFfSypsqi2L5BLMMr5lkOiCziMKGem4V3SBfJj00QuZxBc
	m7jEmRn5HBJ4qNQ3OjrsUYMOMpGpscWpviN1v+ssq9NwOcA/7q7/rKpDYEESe9w7AgmugAdc1Xx
	D2k0MZksmuLcfd+MbMNECtyVUavy6MidTfjNPn+O6RCf96oOrxsFxXBhfsVk8+ndirGRI3DQxlx
	ucR69H0PSFRlWcZcs3jYNXF+LBacYe
X-Received: by 2002:a17:902:f70e:b0:2b0:c2d9:2714 with SMTP id d9443c01a7336-2b2c722e6eamr17379185ad.4.1775697653432;
        Wed, 08 Apr 2026 18:20:53 -0700 (PDT)
Received: from sidong ([221.148.76.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b274756621sm212879775ad.20.2026.04.08.18.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 18:20:53 -0700 (PDT)
Date: Thu, 9 Apr 2026 01:20:37 +0000
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v4 1/5] rust: bindings: add io_uring headers in
 bindings_helper.h
Message-ID: <adb-5cz-PS8VFcfq@sidong>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
 <20260408140007.8401-2-sidong.yang@furiosa.ai>
 <CANiq72n2h5Vj4-_wfPWXf9HO9UouaKtVKmoTGQeE-g+N-MYUPA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANiq72n2h5Vj4-_wfPWXf9HO9UouaKtVKmoTGQeE-g+N-MYUPA@mail.gmail.com>
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13008-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[11];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[furiosa.ai:dkim,furiosa.ai:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A2A753C533C
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 08, 2026 at 04:31:35PM +0200, Miguel Ojeda wrote:
> On Wed, Apr 8, 2026 at 4:00 PM Sidong Yang <sidong.yang@furiosa.ai> wrote:
> >
> > This patch adds two headers io_uring.h io_uring/cmd.h in bindings_helper
> > for implementing rust io_uring abstraction.
> >
> > Signed-off-by: Sidong Yang <sidong.yang@furiosa.ai>
> 
> If there is a reason for putting it at the bottom, then please note it
> in the commit message.

Hi Miguel,

There is no reason for putting it at the bottom, They should be placed
in the proper order. This will be fixed in next version.

Thanks,
Sidong

> 
> Thanks!
> 
> Cheers,
> Miguel

