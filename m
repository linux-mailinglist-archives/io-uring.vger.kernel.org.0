Return-Path: <io-uring+bounces-9685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DCFC0B504C8
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 19:59:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EFA4A1897E03
	for <lists+io-uring@lfdr.de>; Tue,  9 Sep 2025 17:59:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF3933EB14;
	Tue,  9 Sep 2025 17:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ypbez8D+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10151D5CD1
	for <io-uring@vger.kernel.org>; Tue,  9 Sep 2025 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757440754; cv=none; b=UJpYljbXHTuqwHZvfWInXvtxzqs1z+77vdilEtbaxpArutTtmxR2eEc4PP/je//HGp42V5O54tQZvZL0N6WwhWPEMn3hyre/8CCjrMY5LK3vfbL8olXrtKt3s8xpqF05pHswFKLtr/t+4mohAB8WeSt3bXSRyk/8ZPHgiMIQP18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757440754; c=relaxed/simple;
	bh=c9VmzZbrc+pRtYtQeM+DaVC2B+e5eMlSmeSeLCvR8cc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j5BNqhfWh+bEUZMIh+K0tCbau9HIt+LN32KuQCf4GFn58DGGIPXCTTsD0oqym90sdyDDyjui4oZIXxBV3KVUDKj6AIVKQ0eqLpjkbTU2fGpaclPaWdTSK2RnHvK7yYdGs/MzGZj+kQQyufndxQMqyOkeHWi3q0peZb53pJ85Axw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ypbez8D+; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61d3d622a2bso9625999a12.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757440751; x=1758045551; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=urPTHi+HPKECqvpnFYRbpEebbKe2TRaFUwc8ISijTfs=;
        b=Ypbez8D+DGNbH51MrDtf8znbtU2dPqE/VEZEP3Z03VF+4vo6a3niW/+rZzIZ1Hf+DN
         1Wlw5GdIFWrZEV/X/6Y9r9xgp0qalETFXe2zRZgMaXZ2u4ZNzL09HmtNtRN5nwWMiro7
         8i6+W322T8kuIc642DjTNwF6amtdUXRc0+V5s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757440751; x=1758045551;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=urPTHi+HPKECqvpnFYRbpEebbKe2TRaFUwc8ISijTfs=;
        b=smHUyOmlxrJreeerJ8MSqAz+MLt0PaTkKuv6yG/1b4tH3yhgSkgtq3MXAinJUEvUJY
         4d2DRXgkrbzZM4eWJC8SFbgZ4v6EMzzh2nzgZ/8IfNzrJvGxwIvRRUOeCptvZVN9Tu2U
         ymVaLkFPe4C3JhVNy8y5Mlju2jGCqKvW++gE8izguOJMUO4Kk7AycFfhGX02pSmY2dkc
         e2oO7GrLiSv57YbCEwvXtxfHvjxvPqSdse+BX384u42HSRO5oWDUqV1+GUrfZEtgq1jH
         mWDnsiJVpT0sS2CODDnqVQ4fOLw1KdI/ARDn61/ownKBdvnawlothG7chWUUr7ZmUTG/
         6jBA==
X-Forwarded-Encrypted: i=1; AJvYcCWeZi0EdKNqLFTtU6SW/O95hhiCwFH0GimcEn3tR4E5zkrg7jkQ9eLUxblJpwNBK2q1+/7dsYHJ+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWCQerl2lACoCJotMdeXbbXSijhXV8nkxUaUTInZ86V700h5Ld
	Tqlxsl6AQU9d5Yq2ZVglfOQVLlePnTA2OCnUkFpIzHHDL0a+jY8uPKzpvaDbopFdi5Br0JaE8va
	Rk0b9plA=
X-Gm-Gg: ASbGncuR3VS9FoUQ3ibLDVgcoDXhdEZ4GTatG5ynN4DZeaTQOL+vvrdSwlt9s/eywbV
	bZupGBckrvMyKnDLBjHgzfW10SvyrP1Pgp28IXk9xjbMDTJCO36SNjuJ8Q6eGKo75MVvgfyDZ7i
	c4yfaKdstKF7/SDmtj+y706LqWhSyxyhILTrP9LlZEY0NLG2bYwZWsEyhc2bzBUmlKihjkuYCmP
	8qJpP2jfb7/7kyASb9ROEyvU7SidqUfFnPVkqxa5y7L2nc9llnoFBDfiFX7xTuUm1P6CcAw2zd2
	OGA617jDD2G+YeBKAYzy0DVxDUkVOVnYLCgYQ6vszu/CYjbihwNOTVRMJuWh7Rp4nT+AWWg/t60
	OyYtXZvxXutisjQ8euWAbtXFh01Zo8n3CY4Y76gyrvhRVqOeLDzkjemjmZbril2VpE7O+sA3OrX
	y4bz35SDg=
X-Google-Smtp-Source: AGHT+IEkqDCuIq2q2VFj5Ifly1AzsrWRoo79vZN3BRwDgiCcSm9o8Xg0x4MJUGYIxzCEgb1WnZnFcA==
X-Received: by 2002:a17:906:eec3:b0:b04:6c7a:dd0a with SMTP id a640c23a62f3a-b04930ab605mr1711468566b.8.1757440750630;
        Tue, 09 Sep 2025 10:59:10 -0700 (PDT)
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com. [209.85.218.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07830a460bsm27822166b.23.2025.09.09.10.59.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 10:59:09 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b00a9989633so242930266b.0
        for <io-uring@vger.kernel.org>; Tue, 09 Sep 2025 10:59:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW4NvECZ0s9S1BHDVzbwgdxj6fiG4BHK/0iablCGBJVIfIDmYy1D7m7k7YhuZsdJbqh5onBfUSkcA==@vger.kernel.org
X-Received: by 2002:a17:907:cd07:b0:b04:3402:391c with SMTP id
 a640c23a62f3a-b0493245ddbmr1713526366b.24.1757440749500; Tue, 09 Sep 2025
 10:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <68bf3854f101b_4224d100d7@dwillia2-mobl4.notmuch>
 <5922560.DvuYhMxLoT@rafael.j.wysocki> <20250909071818.15507ee6@kernel.org>
 <92dc8570-84a2-4015-9c7a-6e7da784869a@kernel.dk> <20250909-green-oriole-of-speed-85cd6d@lemur>
 <497c9c10-3309-49b9-8d4f-ff0bc34df4e5@suse.cz> <be98399d-3886-496e-9cf4-5ec909124418@kernel.dk>
 <CAHk-=whP2zoFm+-EmgQ69-00cxM5jgoEGWyAYVQ8bQYFbb2j=Q@mail.gmail.com>
 <af29e72b-ade6-4549-b264-af31a3128cf1@sirena.org.uk> <CAHk-=wiN+8EUoik4UeAJ-HPSU7hczQP+8+_uP3vtAy_=YfJ9PQ@mail.gmail.com>
In-Reply-To: <CAHk-=wiN+8EUoik4UeAJ-HPSU7hczQP+8+_uP3vtAy_=YfJ9PQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Sep 2025 10:58:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh2F5EPJWhiEeW=Ft0rx9HFcZj2cWnNGh_OuR0kdBm8UA@mail.gmail.com>
X-Gm-Features: AS18NWCMkQq-AHmRvXW3fe5pqZS6l4P8uIcvsgrr_gFx3AOIK1O6iaGHEGYcUd4
Message-ID: <CAHk-=wh2F5EPJWhiEeW=Ft0rx9HFcZj2cWnNGh_OuR0kdBm8UA@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Mark Brown <broonie@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vlastimil Babka <vbabka@suse.cz>, 
	Konstantin Ryabitsev <konstantin@linuxfoundation.org>, Jakub Kicinski <kuba@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, dan.j.williams@intel.com, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 9 Sept 2025 at 10:50, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>    patchid=$(git diff-tree -p fef7ded169ed7e133612f90a032dc2af1ce19bef
> | git patch-id | cut -d' ' -f1)

Oh, and looking more at that, use Dan's version instead.  You almost
certainly want to use '--stable' like Dan did, although maybe
Konstantin can speak up on what option lore actually uses for
indexing.

And you *can* screw up patchid matching. In particular, you can
generate patches different ways, and patch-id won't generate the same
thing for a rename patch and a add/delete patch, for example (again:
the traditional use case is that you generate the patch IDs all from
the same tree, so you control how you generate the patches)

But patch-ids are an underrated feature. They are actually lovely, and
git uses them under the hood for rebases etc.

             Linus

