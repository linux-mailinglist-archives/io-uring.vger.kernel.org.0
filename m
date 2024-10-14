Return-Path: <io-uring+bounces-3653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14EC699C733
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 12:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBD7B28350E
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 10:32:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC0915F3EF;
	Mon, 14 Oct 2024 10:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Lff5Gyt3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15511465BA
	for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 10:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728901933; cv=none; b=PSCu3hJmdS/rOY1cObYohGCoGZzOJqb7QLNolbSCPDRUp64L9qqYvEy/gppyJhcY9uonOa6CbeYQSHfK7yPhvgIVd/0p69JolM1BgvEX1Sei+BOhqNU/sGUnYhillL4IjHVzX7k1ztE5y115RrsioGWn6T+u/Cap0HUItiHnPaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728901933; c=relaxed/simple;
	bh=K1Mb94uPAQkxV16KIsPj5P9z/v6aHkKRodKDXfeJhXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kqUwl0leXvkVcCy2phFwPXhwBRkNUz3Vl2Di2Bvqspz9KztZLt7ouSRmhCvf1Cb+xmhs+wqogCvOY6czy4yHLFS3G5QrgqE/tWq2IbtyGkIG2ueKE4mICZBlGn7i7Q8nZxhlpyYMqvptdFm+avBb/ETRZ6jwqiB6gDcCTqY5hsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=Lff5Gyt3; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-539f58c68c5so1239109e87.3
        for <io-uring@vger.kernel.org>; Mon, 14 Oct 2024 03:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1728901928; x=1729506728; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TqqGi2yvd1ddVvt0YYlGimzQhk4gLkb6QoKuISIqyho=;
        b=Lff5Gyt3Xg31LGMN5o8J9bdcFGZBReqzLrSmJJ/suo73a4z6FsFlTHXIJvEz+R0ZcI
         w+9jLmc+ayTLqwZm/euac1+MqPsXooJY1GYujt6wMpwWSmRRrLEU63qZ5K1TtsIbECMf
         i7EWc86kS9KOhhwU5VfMM9xvv4+fPhk0L5Q1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728901928; x=1729506728;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TqqGi2yvd1ddVvt0YYlGimzQhk4gLkb6QoKuISIqyho=;
        b=lt7Gl+Qp0/6CU1LtsWZzlCOQgh1aiFD1ZqYsLp0vu9OJT1rYdB1X0VQnaPaMecTxwp
         Jp45eJyB9n8QILm90SLsKsRVp9chHUkfi0w9bZ5xrQ3MgeiKk33kVOq33J+7IkwaGnVv
         uRsWDS0lTAlm5C1M1vkb4gKior+9O1OZejKwPAeT8sEpXHsDeofeutKiXUGgM4+7B/bP
         WLAsIRINd8QAz5Sg/GA9V8aLPrYmEbLWLgTjmRoJb/1XFMZ7Y6Pq4pfRXYOUYkLb1zQj
         kgkkuSj2rvlTgfIggX8G3tDyc5fX0G8g801C9nExgxpEV0Z2Bma8Za9pMp56CzcfFLF+
         Vq7Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6j4Dy6zd+5gVM8ZovRQb1rfQv4awSyOllmV1vDmh8qiv6Ad4DWLRC8qMZ3dbfhQT2M33UvE76Kw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMKi7oZdqL6uE0xKTLzpos7GnUJmhL+ppvD1LS0AXx8FEI6Fpc
	LYWf9kIJaZXAIqgdsGDvEK/jpNN+UtyMtEJzOQ56cgnvtB3LAzEPArNtsvTIxMnNMijz118Y2B1
	Pe32KcSwaZwKbrDk1k307sPj7zlBsympu8eUjBg==
X-Google-Smtp-Source: AGHT+IEdORrxl6l5F1uvOTpKe5LAhzVGsgZlhGRAfa+0Dgd29D5MvMTR8e6yGRQeuhzIjRRfuZtMZHWhlZVTCtZ+cK0=
X-Received: by 2002:a05:6512:b11:b0:536:542e:ce1f with SMTP id
 2adb3069b0e04-539e54e818fmr4004086e87.18.1728901928528; Mon, 14 Oct 2024
 03:32:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <CACVXFVM-eWXk4VqSjrpH24n=z9j-Ff_CSBEvb7EcxORhxp6r9w@mail.gmail.com>
 <ec90f6e0-f2e2-4579-af9f-5592224eb274@kernel.dk> <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
In-Reply-To: <2fe2a3d3-4720-4d33-871e-5408ba44a543@fastmail.fm>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 14 Oct 2024 12:31:56 +0200
Message-ID: <CAJfpegtGzcJDN-4jMS==C=EeRiW2rqOBzXnNYLKRZeLOQg3RXg@mail.gmail.com>
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: Jens Axboe <axboe@kernel.dk>, Ming Lei <tom.leiming@gmail.com>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"

On Sun, 13 Oct 2024 at 23:20, Bernd Schubert <bernd.schubert@fastmail.fm> wrote:
>
>
>
> On 10/12/24 16:38, Jens Axboe wrote:

> > That may indeed be a decent idea for this too. You don't even need fancy
> > tagging, you can just use the cqe index for your tag too, as it should
> > not be bigger than the the cq ring space. Then you can get away with
> > just using normal cqe sizes, and just have a shared region between the
> > two where data gets written by the uring_cmd completion, and the app can
> > access it directly from userspace.
>
> Would be good if Miklos could chime in here, adding back mmap for headers
> wouldn't be difficult, but would add back more fuse-uring startup and
> tear-down code.

My worry is making the API more complex, OTOH I understand the need
for io_uring to refrain from adding fuse specific features.

Also seems like io_uring is accounting some of the pinned memory, but
for the queues themselves it does not do that, even though the max
number of sqes (32k) can take substantial amount of memory.   Growing
the cqe would make this worse, but this could be fixed by adding the
missing accounting, possibly only if using non-standard cqe sizes to
avoid breaking backward comatibility.

Thanks,
Miklos

