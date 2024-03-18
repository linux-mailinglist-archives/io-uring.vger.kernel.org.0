Return-Path: <io-uring+bounces-1113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 110F387EE70
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 18:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFAA5284465
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 17:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE0454FA0;
	Mon, 18 Mar 2024 17:08:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56D854F8F;
	Mon, 18 Mar 2024 17:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710781738; cv=none; b=jrg5vkmgNqKoYNswJHJq7Zm821DWJnA6NXHDjqT3ZX3ZE1ug+t3Ijve7N8nySrIoylepM1McWPPQ8EhkNXOUXHHqvyIdR4K5d4s6ApVoDzABdZ7cukvkFf4/0QSbYM2+YOW9x/pjtA2YIIR1E4gR2vKqX8ghkA9bdY2DJRo4gKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710781738; c=relaxed/simple;
	bh=QwHWQ9oVAKrUXIiDOCxt+dC+IBc22Hj8eUU9ks1tmGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HbQRmVgDR2Nql+gSiAxynZlIPmYm0NFawBkUMC2s2Y8fmGhICxbfOWe/vEmf9P0BAMCZ+jq4QM9JEKO22ta3BoY+P/DSbcqGfSc4mZaBHEjLbGh/BsH9MBrRSDUV8tGTZYwg4bJvvIFWaqOaVErvTeBYCe8ZRsHpEIGzIv0G3+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-221b9142995so525913fac.1;
        Mon, 18 Mar 2024 10:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710781736; x=1711386536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QwHWQ9oVAKrUXIiDOCxt+dC+IBc22Hj8eUU9ks1tmGw=;
        b=qanlWHQgAwhm4UzeZG1ztlFrRnwJllDTU162hcWORirEfYaBwkGWMPMMVWQVWRmvrM
         2aM56pqE718MhFNE9zZpll0XUBrAseiAdoiMn3n7oU4us2Hmgcuy2EDChI63jo8rjrV+
         e2oAHmaO4Pi4epuA/GMpNj8RSiedRLL3Y2yibn6DaJpjD7owDjEOxVOjIjc7bvUrAvYy
         +ll/Co8PYdwbYj4NJFWlo6MR9X01MZQ6s23pHqUT90zmY/6Dt9ZcRO5dX/0bOxKPEBT1
         2WD9nXxVoLaBnIjStMgphFEEw4y9skFdopgGTRU/v5qRTh7HojzigLYA33sBkffjpYNC
         dMew==
X-Forwarded-Encrypted: i=1; AJvYcCVp9ctzUUrjZW9rmfzkSyC9NLexWzwXNyoqjo2/9BHnCHqBGiuR8OLTsKQBoHYA0QpCZQ56doRixLBPGzXDCjpIkhzb+DHSteto0k59yS24oF60MTu7NKjlyn7KoTZst9r9Uei7iLoHdqFcMdF3ytRQlA+TaHa6I7W/C/z7EcUdzMJ537j9XKhSqf1sVfCGlOmkO8CGwfDdD8Nb573K
X-Gm-Message-State: AOJu0YxHcQg9/HYJsa/1AOG+m42BSeOGLvVQxRo/faa4YO7XDD/e7QWw
	jzyzYx+HhORSDuYJFnoAaTxrLu3qdW59hIjC6rSAl9jEdEGT34+KEh3W0vZkrj2vWIsvb1khk/F
	n7LcnaxwP0agde6zooz+b3S6kOKI=
X-Google-Smtp-Source: AGHT+IFU7ySp2yA6a3YBxEXR8mYGdkkkJdvrmABYe/2rvHFZsvnVOljrXQU7zyXiegNEzdjFq+wOCy/iFGzXd3MpLKs=
X-Received: by 2002:a05:6871:5b14:b0:220:bd4d:674d with SMTP id
 op20-20020a0568715b1400b00220bd4d674dmr12937170oac.5.1710781735835; Mon, 18
 Mar 2024 10:08:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240304201625.100619-1-christian.loehle@arm.com>
 <20240304201625.100619-3-christian.loehle@arm.com> <CAJZ5v0gMni0QJTBJXoVOav=kOtQ9W--NyXAgq+dXA+m-bciG8w@mail.gmail.com>
 <5060c335-e90a-430f-bca5-c0ee46a49249@arm.com>
In-Reply-To: <5060c335-e90a-430f-bca5-c0ee46a49249@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 18 Mar 2024 18:08:44 +0100
Message-ID: <CAJZ5v0janPrWRkjcLkFeP9gmTC-nVRF-NQCh6CTET6ENy-_knQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] cpufreq/schedutil: Remove iowait boost
To: Christian Loehle <christian.loehle@arm.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, peterz@infradead.org, 
	juri.lelli@redhat.com, mingo@redhat.com, dietmar.eggemann@arm.com, 
	vschneid@redhat.com, vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com, 
	adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de, 
	asml.silence@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024 at 5:40=E2=80=AFPM Christian Loehle
<christian.loehle@arm.com> wrote:
>
> On 18/03/2024 14:07, Rafael J. Wysocki wrote:
> > On Mon, Mar 4, 2024 at 9:17=E2=80=AFPM Christian Loehle
> > <christian.loehle@arm.com> wrote:
> >>
> >> The previous commit provides a new cpu_util_cfs_boost_io interface for
> >> schedutil which uses the io boosted utilization of the per-task
> >> tracking strategy. Schedutil iowait boosting is therefore no longer
> >> necessary so remove it.
> >
> > I'm wondering about the cases when schedutil is used without EAS.
> >
> > Are they still going to be handled as before after this change?
>
> Well they should still get boosted (under the new conditions) and accordi=
ng
> to my tests that does work.

OK

> Anything in particular you're worried about?

It is not particularly clear to me how exactly the boost is taken into
account without EAS.

> So in terms of throughput I see similar results with EAS and CAS+sugov.
> I'm happy including numbers in the cover letter for future versions, too.
> So far my intuition was that nobody would care enough to include them
> (as long as it generally still works).

Well, IMV clear understanding of the changes is more important.

