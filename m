Return-Path: <io-uring+bounces-1106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF1AD87EA8E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 15:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47182283043
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 14:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 256DA4A990;
	Mon, 18 Mar 2024 14:07:45 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13954E1D3;
	Mon, 18 Mar 2024 14:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710770865; cv=none; b=IKuWOXPRORqmxcKKppSVcw98QgAG58602KMoP8zUEkLRKmsZUT/b1nHaKNTapgnQ2ZLI4qH9gw/s11xlUuQ+8n5BusrfP/D/yURrCZQZJN1bZRjSjm3cVXnYqhkgyTgAyka3nqF5BecVetj8bEIYGtaHxlXMs20CpwI4RmEqZco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710770865; c=relaxed/simple;
	bh=Wn1lQcXTqfPvFBpRxXswobUk4JknmyEX40y5OAXc5vU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CFkt+DJzgSTKj7cL6TKbHaroqJzGPkRt0wEuk5Z30WI7aBewETzOtp0iW5sYkoF3XgARW7S3DfheaXwbBX0czIENKtnPAxbDL26EFHqZaJ3+hQMuNYE2ZgMbrxBoTU8c0EDIevxVVTZ57JZ0DHVwCtJ/bayJg1bb1Brc0Er3J8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6e677ec9508so319393a34.1;
        Mon, 18 Mar 2024 07:07:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710770862; x=1711375662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wn1lQcXTqfPvFBpRxXswobUk4JknmyEX40y5OAXc5vU=;
        b=c58Wq5mq5YMdnhj5qehoibaL31/oDzXMfx/23/KX/m2iE5igQIgLT8DyF+BU+Nrtc3
         Hffpf0LZ+KC36b1YocDVO92RYeuuSHXa2l4MvhoDW1sImgwOw7JdipVntlHFqwahkygC
         p3A+iW+o7nv7/s7EQltNlQJpJW75jIZlU/1tezi4hBlID6QrEWkGUR6Kk4Rd+AvywY3c
         96feTLDG+6T5qmxaDGwyR/bIpSHCNYzRAjiEAGU6rgYdawjESo+TSFmLN/1s2XY3SbJb
         RV8Hsf8MSjdUTL6qD37gR14Oi7z0r9alsbr2hvtVMNHmwvqDHAqeaTvwzU9cMTrSFLRk
         OoKw==
X-Forwarded-Encrypted: i=1; AJvYcCU3bg087vGurN22jBdZ1VKXs9e+yB0trgcFri54pvZHb0olCgYzfNGgKxM4lmM7ESBHlKgxf3+dlHsvffakO3+CR8cxJwNovFLJJQTi2iIvhIZCdyE4SwTtnuJSL0rLOV5LToGNESSX+09smI3NibcERencNrjzZ3Gskh6h940R
X-Gm-Message-State: AOJu0Yy/Rh2+AKB+fr7/Vki25pPY6ASsUiz6Zevint7uuibX/Sc3NING
	oVwVVBKWq+6jbjDvGrEVGP2PfR9CWiCO36hwKQgQ9plzy4UJB9+KKYVtzfQW7uclEWNgAhirx67
	uBqgQilaTFTAdjzgY4iY4lj2YjQA=
X-Google-Smtp-Source: AGHT+IEnt/T+QhS18bU4bTnW0vyP35oKalbVYz3kh6c39m2U5Q/+MmVhAreB9JF1RzGRJu9CQirfKD4Z/lQSCnnsMw0=
X-Received: by 2002:a05:6871:b28:b0:222:8a9d:d935 with SMTP id
 fq40-20020a0568710b2800b002228a9dd935mr8792017oab.3.1710770862637; Mon, 18
 Mar 2024 07:07:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240304201625.100619-1-christian.loehle@arm.com> <20240304201625.100619-3-christian.loehle@arm.com>
In-Reply-To: <20240304201625.100619-3-christian.loehle@arm.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Mon, 18 Mar 2024 15:07:31 +0100
Message-ID: <CAJZ5v0gMni0QJTBJXoVOav=kOtQ9W--NyXAgq+dXA+m-bciG8w@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] cpufreq/schedutil: Remove iowait boost
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, juri.lelli@redhat.com, 
	mingo@redhat.com, rafael@kernel.org, dietmar.eggemann@arm.com, 
	vschneid@redhat.com, vincent.guittot@linaro.org, Johannes.Thumshirn@wdc.com, 
	adrian.hunter@intel.com, ulf.hansson@linaro.org, andres@anarazel.de, 
	asml.silence@gmail.com, linux-pm@vger.kernel.org, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 4, 2024 at 9:17=E2=80=AFPM Christian Loehle
<christian.loehle@arm.com> wrote:
>
> The previous commit provides a new cpu_util_cfs_boost_io interface for
> schedutil which uses the io boosted utilization of the per-task
> tracking strategy. Schedutil iowait boosting is therefore no longer
> necessary so remove it.

I'm wondering about the cases when schedutil is used without EAS.

Are they still going to be handled as before after this change?

