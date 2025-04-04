Return-Path: <io-uring+bounces-7411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF04BA7C649
	for <lists+io-uring@lfdr.de>; Sat,  5 Apr 2025 00:27:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7393A17BBE4
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 22:27:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA4AE1B0F30;
	Fri,  4 Apr 2025 22:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Oc2ZgsP1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CCA19047A
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 22:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743805628; cv=none; b=ahB8oDMMh4VC46QOXBzEIxi6HM8AOC+qIiLqZATxfTT0D4b2brdRbPoTPdJlaiicj0G4brnQTbFrG3TbPghrHn5MR3n467fVkU9kgdV2AH62VJGoCWMXB11ogit4LnHn/EXjYiKu74Vlctbvjl+JdvtZW6SsEv8amylSv9WW314=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743805628; c=relaxed/simple;
	bh=oDB4FOmqbfKc1ikhTffNPxD6xNsSA0M2/yxz609lUHo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=QnoBUKuIP3/9zq0qoSY5U+J+QYeo1YJjo0GjaCFx1dwadzfen+wY/qr0hiVV9xkpCW9t9RnZ+JEfWsazb3oJGa73QLpm7pCi+oUMxzqv2Y0USXP8w9kkayvOrC6xXzB9mW5jg2ipdb+763nRr1BJJUoWpwO5cWLDQ+eLvf6mUhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Oc2ZgsP1; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3cda56e1dffso12594175ab.1
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 15:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743805625; x=1744410425; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KnXKzRjUwS68PKHOAd+R3tn7FfZvEPjHDBFqIRHSypk=;
        b=Oc2ZgsP1KxpZcBWhapIzaABigJ6gIUGMVqWP0uQvBa6RGvgAUMWpdo2BK+IOyEWchP
         imgfJLcAVNucBoaY6OEgRRpkdGzTwCH2uQ3MxeUGe714bB79+Zjf0NYqqwyGBVrbFCFl
         LEjzR9rsaUV4+wON0hTqfjvkWU3jIQ3t+8055FmJbuKMAKRvMqhYZuiJSN4pekSgc6MN
         QJ3c6xtSzZmvwDaUY7HlqGXCt4Z5ZhVq+QC6YTYBe+9j8SLWY/NV2yw3PPMTF85D9uO7
         jcmSnEd7bmyTCxno4Suk0sAHAqJn5XC5B7HrEgQvCz/HTkTHeJO/mRkqY2MBfCS2pOYx
         umBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743805625; x=1744410425;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KnXKzRjUwS68PKHOAd+R3tn7FfZvEPjHDBFqIRHSypk=;
        b=a0d3+LrP12idCkus/X5i5HUnWuyRJRWfZqmT0EPORFZs9OqPmvy5HDoj778wmahjQs
         7vD9dEn6YKwWLNkrh6zig4XMDwO5Q1HY4MwHBoCP1NHhmOVyRWZ1f0i12Y9Nk6lc28r2
         RJ9qPDNMTjqg9Jlfx9oc1Xr8tMxCk5f9a7X4ZHz7m2I9puev+Yru0jt/pK6QvHSkfo/T
         GKj2UZ9Ei7oK9v9IOiqUzpzAEVTrbDhz/Z80mMzLo6JEV5rjnfbt45pnBNsM9dazSXil
         ToRwXpq4fGx/PcOu5OarIcjsbBFBJYb1r2vI4NWPiWHSb3/7X5UopMfQyrd31O396NI/
         SQ2w==
X-Forwarded-Encrypted: i=1; AJvYcCVXJAclo+At4/QDBho7IaMe/kaTXovtEk+i5heF/PjLaeb379ErQXSStK2XZOpbA1+8idB7wu2U/g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf9KyxUGpMFzkm9G7cLy7IhrxnZyWAkMQ6rGdEEKT5eXpE5Cfx
	HC67QkXOmTXTrHT1R44MtL3ttgnucn3LO6pnE51M8SpTh4hq+1qviAKrDt/Ktks=
X-Gm-Gg: ASbGncsNiazAYmys7rqswbkz1nKXH/0lOahq/38Xdi6f5xzgeawiyIijwLu/vhj8zJF
	8EOfM56spw2W2hue0t9TYP15u04L4IECElkE6YCHUdXpL49f4n0DZL58C8RSuq5aukaKsOS9JDE
	PL/lh6TwYr6nNWXhGxGKq31Jsf+X6ccWt5qPBz4GvNtFHhmWpUqRm8lhgxjtH4J8m8cTclKiCuk
	3ircbXyI+eLX53p4RPnmjRPWFl0rZSlYbqgpKmwRGlBFW5I3zmL+JoVtK4vZu5ciK09eWiBCi5v
	KlYpE9zPfijbE8jl09lCRnIcIPE9ZoHi5uzcseYNwA==
X-Google-Smtp-Source: AGHT+IEgfnLlKAzuh1GsWc2Ym5gBelLO47cG+8FB7ArPAEAWjADWt9YtIwfc3C/AqJZ94vb7llKBhQ==
X-Received: by 2002:a05:6e02:338d:b0:3d6:cbed:32fa with SMTP id e9e14a558f8ab-3d6e3eea4b0mr60058395ab.5.1743805625207;
        Fri, 04 Apr 2025 15:27:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de79f182sm10348915ab.4.2025.04.04.15.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 15:27:04 -0700 (PDT)
Message-ID: <7472b072-9c08-4e5a-8f16-8a56647ebc9a@kernel.dk>
Date: Fri, 4 Apr 2025 16:27:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
To: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <671c817d.050a0220.2b8c0f.01ad.GAE@google.com>
 <5ed947b0-5762-4631-8633-b737bc09eebf@kernel.dk>
 <b51adba8-7722-4f74-a865-47bf1638820f@kernel.dk>
Content-Language: en-US
In-Reply-To: <b51adba8-7722-4f74-a865-47bf1638820f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

#syz test: git://git.kernel.dk/linux.git io_uring-6.15

-- 
Jens Axboe


