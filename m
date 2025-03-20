Return-Path: <io-uring+bounces-7151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8688A6A8C1
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 15:38:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DA553BF94C
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 14:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AA11E47DD;
	Thu, 20 Mar 2025 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LVzqQcNF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F911E0DE8
	for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742481436; cv=none; b=tEkzz1fPl0TppNTPgtKsFvADxz5w6VyGdh9SGZxG7Lmk4EyJ7wT1s24iWJQweK0swuO1Vom3hrSFvZtGCECX9JFI5eeut4QBr1tbZxTAIKBjhAyFYHX05y4J70mJScSBVrVr/lWRlfcyWQdlhcttsG/NFF9LG6cXUJ22RNm7+Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742481436; c=relaxed/simple;
	bh=dKWHt6FujybyOyL5cedYtqrafz17Hc5CfWsQ5YrnuQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iWzXIoLTbgLarKeHeFskCcq/j5YoN+jFD707Hik/Sr1IuoFbCAP48Yx1YVBFigCHiBPcI6e8r1HLtJo6jmWhxqpYyP8Q1AWCOILzDQZq/+7XZASjXf6yDJG/YW3h3hJU9fsVhAlW/hOvyORbNQnwgeIv7Zs8RCEU9AU2SyBPJck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LVzqQcNF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742481433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OhfkO0nOeFh31dBWlpIBHPp/23oMIm4/ZzrV7nDHXfs=;
	b=LVzqQcNF5lFnNgzkRLDogBItBVTSgR3acHVWsqaBBBvy0NPqsrbCc0UhJkDvq94vWcFaPZ
	4d7m7H9Zs+Fr5cVTV5lwjqqxpevX2jQMx+qkpz92rVgOVrsazJ7UzcWwHRe8gte/2Q7rnx
	FIhbRRmgrmKUZ5WLAv8WcKC5gIF+Ft4=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-on54QT7bNRqmD8tW4IeGRQ-1; Thu, 20 Mar 2025 10:37:12 -0400
X-MC-Unique: on54QT7bNRqmD8tW4IeGRQ-1
X-Mimecast-MFC-AGG-ID: on54QT7bNRqmD8tW4IeGRQ_1742481432
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-523efd77006so299208e0c.1
        for <io-uring@vger.kernel.org>; Thu, 20 Mar 2025 07:37:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742481432; x=1743086232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OhfkO0nOeFh31dBWlpIBHPp/23oMIm4/ZzrV7nDHXfs=;
        b=fEBtQ1S233B9TCp8pmj3HazP9+ueLhF/IoIZoSSVQYGVGaRUDcAIPptx7E4oyJhTV9
         0vU1iWp9WsMhBp/oJsXyJP20dUnFttkqJGlqGIIvGLFsOBAToatZWhmeVyWi8sLudC63
         t5aFt93/GkIi+6/CPOEl41KY06LB322MYgVspU6YsmhPdjdXIUIQFMUnLAj2dgjfWECG
         vqQmx//imWOnPsSaqWYymuzNuHZMOL4rkmcvrcp+33wtmBdjdyxQ79ZfDf3WQeMqk2wE
         C6HmbOozl2kf1y+KifU5TtoFuOKrpOCoEcTjJ7pAx3FfRFfsbT39fWBiaiK2rnslUwel
         Dq3A==
X-Forwarded-Encrypted: i=1; AJvYcCXWJpr8CM10CeMxLDaSj7zvZFPekSWahORNpsTIsCqvZLUIwADWWyyv2cS8XMsb0U5a25bl8jGAQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwSn75RtWtjRxVIjN4LFDQZ075mU/ig0N6eQT1Z3f0aY46Vztj8
	dNaex+Zp6Z3+VLaLkJLyYvltTVx6rFQ4/6jjG4Oj50QAncOuFAWARIq/R4/6WlwyJ+fSwuS7VaN
	PrI7Rt4zVL3lc5g2VkD6NRoSaR/NKRqJHhL3wAkzXjE+K5zYimurFOFHjq0MyLRB0XwW6yqWf/C
	KXK32lXGEryHOtln4O/R21ppc6RZ8GxdE=
X-Gm-Gg: ASbGnctrU6FvKwMbjf19eVaQVrETxBqmE9PWXQHhIKpJpEOlQJJAebgQ0MZKV/IBV0S
	Wa5E1Ya/a/8BE/1BL0sqaILZHMeESoa2jAvd6XCLZXMlStkwIbcZJl2OHsgpKxKXEW2HV2Lc4pA
	==
X-Received: by 2002:a05:6122:608b:b0:520:60c2:3fb with SMTP id 71dfb90a1353d-525960812c0mr3062144e0c.0.1742481431792;
        Thu, 20 Mar 2025 07:37:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGZzOib+M1uSgBNdPU9As6RS1qawt2FeKNo41kWJkJdCE9L3Fh8fjGANZNClbTw9gJ8Xn1+es3nosLVtfd7E60=
X-Received: by 2002:a05:6122:608b:b0:520:60c2:3fb with SMTP id
 71dfb90a1353d-525960812c0mr3062090e0c.0.1742481431364; Thu, 20 Mar 2025
 07:37:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z8-ReyFRoTN4G7UU@dread.disaster.area> <Z9ATyhq6PzOh7onx@fedora>
 <Z9DymjGRW3mTPJTt@dread.disaster.area> <Z9FFTiuMC8WD6qMH@fedora>
 <7b8b8a24-f36b-d213-cca1-d8857b6aca02@redhat.com> <Z9j2RJBark15LQQ1@dread.disaster.area>
 <Z9knXQixQhs90j5F@infradead.org> <Z9k-JE8FmWKe0fm0@fedora>
 <Z9u-489C_PVu8Se1@infradead.org> <Z9vGxrPzJ6oswWrS@fedora> <Z9wko1GfrScgv4Ev@infradead.org>
In-Reply-To: <Z9wko1GfrScgv4Ev@infradead.org>
From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 20 Mar 2025 22:36:59 +0800
X-Gm-Features: AQ5f1Jr8FjeQhNt7BbY6PJzfG3RS9LN-fvPsePmLRNjHLbVpaQVZTtsZ8BaAdPI
Message-ID: <CAFj5m9J1BGiqG+P+7kidH4V0hR9f-BmUar=0ADDR9wpGbnWSZw@mail.gmail.com>
Subject: Re: [PATCH] the dm-loop target
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, Mikulas Patocka <mpatocka@redhat.com>, 
	Jens Axboe <axboe@kernel.dk>, Jooyung Han <jooyung@google.com>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>, zkabelac@redhat.com, 
	dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2025 at 10:22=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> On Thu, Mar 20, 2025 at 03:41:58PM +0800, Ming Lei wrote:
> > > That does not match my observations in say nvmet.  But if you have
> > > numbers please share them.
> >
> > Please see the result I posted:
> >
> > https://lore.kernel.org/linux-block/Z9FFTiuMC8WD6qMH@fedora/
>
> That shows it improves numbers and not that it doens't.

Fine, then please look at the result in the following reply:

https://lore.kernel.org/linux-block/Z9I2lm31KOQ784nb@fedora/

Thanks,


