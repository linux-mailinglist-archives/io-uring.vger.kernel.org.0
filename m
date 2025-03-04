Return-Path: <io-uring+bounces-6958-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6610A4F1B1
	for <lists+io-uring@lfdr.de>; Wed,  5 Mar 2025 00:43:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A0D1188C4ED
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 23:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEA20251790;
	Tue,  4 Mar 2025 23:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PeO2Qd9z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A451FF7BF
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 23:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741131814; cv=none; b=h/lWcdYfYvAc7hVjlB058xucNciB+niLz/I0X3SwhMxwuKUNIhZwRzRNRsmOnVmDusKYGT5+vNqt5DUkis5P20wOnxeJo3q5/ncX/1EEo5Qjx0oSTGWuTnEeEmRlZb1Brab/lN+CXrvRn3sCYthzSi7f+iDPwHkz5ItSbuzIkK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741131814; c=relaxed/simple;
	bh=LQ2dObE9xnjHqX4o4VZ6lldO1Qoq22S95Oe8bf3ZaRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lc5onniD3Rg2JAza/iITMOalgfNokrxotrlvBiIGHfHI3JZHBlXkyb56q/DL25Bqyu3/GubFnQX43s0tSe2uhD8EogGFmDY/OEUUBTSG49A2GcFnfk16pPeGqfAz23NEV63ilC62aNygMzPenGXaY5a7x/jWiT/+ZJf5zHBoDhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PeO2Qd9z; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d2b3811513so1009025ab.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 15:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1741131811; x=1741736611; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=adL3a2anGdh9vo2wHq8fefFVpNlV6pB2upjJtDZhv9U=;
        b=PeO2Qd9zxnVs3UcbSfhqR6qottgXEhCLXw476JOVPf6U2G3JjzElJ0ij8NCpPVzOA7
         emwRXD6wjFsG1xNFFgSGtn8aAYs+SBSvdTx7T0EAmRseNYrXDG920KGKyVQeixdyup5w
         8Wuoiv1iKaM/MeWQhUTjKhu4El+LUelxkaj7ubJhJIWM5qeIENpo7KmoQnHmbIL0RMej
         2KTV5Gtjm0Sjpgq2Ap6Onga9ZAzic1gHgVSzzsGp1D6klhprqFxyGKy+vJzQ53ezB8sV
         2nUMvXwVXXEuQCDKoR2V1hJ0KfNndt3MmCSPp1Nlt0FWTE6m5p9rEx9OWNNCrPiI2iKl
         4G7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741131811; x=1741736611;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=adL3a2anGdh9vo2wHq8fefFVpNlV6pB2upjJtDZhv9U=;
        b=esITYpzwBxJFjSfxZ3pvmTpZjLYpSLQDJKYTFXhiz5FjeNsDlFF0Xz/qDWu9b+l5d/
         Je0GRB8m/YeNhEQR/8+iBxqJfq16gUONIyhpVZJafxfQ54Z4X44RrwWc53LgCUujrZwX
         NtQFQGL008c6ZuwZIa0KDfGa9LFjUc6v2oe26hEA1vMnJ+W0rFmohAkvLMka6QzfmsQb
         fAn/8OoD2O0ezK3+pBeTiyfN82kAoXkSo6T5uRofTiLiNHq9uQe94Onq6SgRMRGXS1Is
         Z/4sJ1b93McgQ4LslV4IwcmcI57TmcRvlrpR0Tni4Rr+xf+XzvzrYhUvcjzCzy9/5wby
         CseQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYUwigUhHIQ6SDPynH6gUbXBZPONw0vTRsHBspknF8qUgffllC3Le1Y+OaKloJq5E1r/uMWSqGog==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZBiR0ApaT9XNNi0lCRSo6yg7G4wTmGLGWb1TI2Hb8k+oXs3qy
	XdXlLk70ZCedh+UEhCqJxZuOMOhWYsFodzdtZ5XPY9wnVwOcA71K9nFlSXhyWBI=
X-Gm-Gg: ASbGnctDZp2K4vQQSRLuVf6ouym79JrhGiMRqCUVA8Hn24L4DkXW3c026372dcHN+3c
	ntZSJ0dSmB8JfwUoaNYN6XIXlRRpMBhsAycYXjbX/YOyaB5al6W5+b7/FraAjuxOHqvfdO4/Pez
	G2MVCuk4Fgs6vBhSW/NTQVdHQYchWWWwoCoxNgpTq3qkZ7cNMVeLsd2EYduz/nIO2F9tRuJZSM9
	lLQ+FiSwD5s47JmYFpAzXz+B8dIXCWUret33QARPZGkB98Cs7frxpyk7HZ0Wk2PCwsrfv5/fPDS
	MtedNn4sXMOHulq5hGF+NniwcAKzQrvHnbCTAzyM8g==
X-Google-Smtp-Source: AGHT+IHRIfVPTO2H+vhGXg2gihyT9kT8cJpre62fDKYP0upABmDl9eg4B1dQhkHIWNRySymN6Tqkfg==
X-Received: by 2002:a05:6e02:12e6:b0:3d3:fa69:6755 with SMTP id e9e14a558f8ab-3d42b96c243mr11906105ab.5.1741131811472;
        Tue, 04 Mar 2025 15:43:31 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d428e8749asm3788845ab.43.2025.03.04.15.43.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 15:43:30 -0800 (PST)
Message-ID: <876fa989-ee26-41b3-9cd4-2663343d21f7@kernel.dk>
Date: Tue, 4 Mar 2025 16:43:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Christoph Hellwig <hch@infradead.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 Dave Chinner <david@fromorbit.com>, io-uring@vger.kernel.org,
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8clJ2XSaQhLeIo0@infradead.org>
 <83af597f-e599-41d2-a17b-273d6d877dad@gmail.com>
 <Z8cxVLEEEwmUigjz@infradead.org>
 <1e7bbcdf-f677-43e4-b888-7a4614515c62@kernel.dk>
 <Z8eMPU7Tvduo0IVw@infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Z8eMPU7Tvduo0IVw@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/4/25 4:26 PM, Christoph Hellwig wrote:
> On Tue, Mar 04, 2025 at 10:36:16AM -0700, Jens Axboe wrote:
>> stable and actual production certainly do. Not that this should drive
>> upstream development in any way, it's entirely unrelated to the problem
>> at hand.
> 
> And that's exactly what I'm saying.  Do the right thing instead of
> whining about backports to old kernels.

Yep we agree on that, that's obvious. What I'm objecting to is your
delivery, which was personal rather than factual, which you should imho
apologize for. It's not that hard to stay on topic and avoid random
statements like that, which are entirely useless, counterproductive, and
just bullshit to be honest.

And honestly pretty tiring that this needs to be said, still. Really.

-- 
Jens Axboe

