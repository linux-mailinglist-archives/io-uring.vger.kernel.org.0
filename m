Return-Path: <io-uring+bounces-5485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F247D9F144C
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:49:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EA24169AA1
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 17:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 005BF18452C;
	Fri, 13 Dec 2024 17:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="j4DUC7DP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C96632
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734112144; cv=none; b=VqKmNG6y7uvN3EPyvZDAn7HOqN6/MS9MauYtn7sFskbc6mJDIOxTyQvv4YMomhbVZ1xRJ41zpF3Svzz+m1HHxHCfoq0RpLre0IlTBQD1ufjW4iOKaCpByK3Rb59Pxlkg3AMnuzMqLawQ/qbBr+AUGAqV7wv4JVggzA+VwPkHWnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734112144; c=relaxed/simple;
	bh=Y4LeC5RXGp6H/KRsO20vJmGW1ptiuI4cDc+DzYUyPko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qVXuAMY4j3A6XXRzeq8kWRl7oiV7miJ3YR/F9ZQt11iQU+37H2M4S9j/g46mQSy6WWvRbuL8G+ylt9WQClPVDxMeZD4HrBl5Rq9IwzYuWpZ6nnOhk3X9szzijZ4cq293jwpSUV5e+mH3OVuXQV7oTz9hIBcyI+VdUFXzBgQM+0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=j4DUC7DP; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83eb38883b5so67009439f.1
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 09:49:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734112143; x=1734716943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CcTujtpSjvlWaI5ctqnscgJNM+ozrNrJa3iEX3J3FPU=;
        b=j4DUC7DP3ckWeWBeyt720e83nhooO+osm+Tajbnfe0M5f0Am42vXi7hOC7Fy8vfGy1
         IFOt/W1sePCn1ECRrFtVEQQU59/vhwzbmiV9msvjjqwNqWlF2CC6uvOS2oaxwFgI93Z4
         KnVns3lf407otLpmQitn9kOrG87Acsljql1TD5G/Hnf8frZ84TwuYQErwIVJwUnWLHiD
         llDcDlwgSBwHOvwmArtI2tDa1EZ9aDhIvmIVkgySu6f/jZqhLubuqO955xf+/jIK01J1
         MToSlJ36OAYgV6zRAezQC/ElSueBBf81x/qX9XewrhcfRLe7lC48t7Z96GseX4nlX7jd
         5org==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734112143; x=1734716943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CcTujtpSjvlWaI5ctqnscgJNM+ozrNrJa3iEX3J3FPU=;
        b=PGJEatOzg3B9AuM2VNRqS69r7gysUn9XjKIkFyZT3MzvtQ25gvbL5o4Sw+r90ik4/n
         IInAORGCR0/drRg7/qkLwc9RuCBWhQQM8eJsHkPNlv9aFP0RCoGSy+qQ3dql7ToKzI4V
         BD0HZKxge1kmo9lEoD4BEU+KZpyFvTwDnf11KxfYdc1wonert8qJwZhfkAEuGJIKuuyf
         Qee8oGKbCt205zRPY4w6vvphg19e8wm36OruuGW8+GGH5N9DUh1vnoyhUjw0X6ExXHQZ
         WHwYEkE365V+i/6OcMU4/+mj9sjhaiYMnhITgvxAypVHI1FQ2WHW6D8NfeOA1Qe8Q4xu
         thOg==
X-Forwarded-Encrypted: i=1; AJvYcCW9ZImd4+LGHEBqeJlH2lFIE6WnV5bkhsjMrmDiVLxkkUIoZrVxUx1znk672cgc1lKQ+nKPpK331A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyMWWfH2G/Giu0lwPQ+2RN5hc0HjgKV3Xl1Pk5fg65ynzoblvnn
	7MWvM0n8ML7AaQ/e/65OCf1H98KYTHb4vguckaNPFlTGkwimPgaNQ3KPWjsnD3E=
X-Gm-Gg: ASbGncuhWk9+p1ihQ32wGnlTzRAxXujNmeC+KS3zqsTngnucASifNvMtjS+PT68lGj8
	yMh176L0fkgWb6VJzmOm9DbevRQn6181hqGlLqhkP4LDJ/ekZC/dZLF64DSSuw3zJaH13Jhy80F
	8Ra0RAH2ECR/w5Bx6GWPcOokTjv6ZhfkhgwU+6KzP4N7tcQbn97Uqw4u0QCjVwMDLgp0fH/TEls
	TtN9/MFHVApA7wxQdRYYGUc/U0WL3JCHNnwKohzjWab9i/ACe2t
X-Google-Smtp-Source: AGHT+IHTNp8YhuwjrOvI0UFfn5eCTMvVJPRKHYRZYXF4sT0Up7xIIztoFPfY1lE5LUD4a32wxrxMfw==
X-Received: by 2002:a6b:6105:0:b0:83d:ff89:218c with SMTP id ca18e2360f4ac-844e8835294mr323326639f.7.1734112142749;
        Fri, 13 Dec 2024 09:49:02 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2bff662b7sm2704740173.103.2024.12.13.09.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 09:49:02 -0800 (PST)
Message-ID: <2310bb0c-8a8d-4520-a1ab-40a0489312e5@kernel.dk>
Date: Fri, 13 Dec 2024 10:49:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in get_pat_info
To: chase xd <sl1589472800@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
 <ca3b85d6-ddbf-48b9-bdf5-7962ef3b46ed@kernel.dk>
 <CADZouDTH=t7WTFgrVyL_vYsJaWF4stjAj5W8NF2qAK0bW2HVHA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADZouDTH=t7WTFgrVyL_vYsJaWF4stjAj5W8NF2qAK0bW2HVHA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/13/24 10:47 AM, chase xd wrote:
> The bug was found in October and the newest update on lts5.15 was on
> 2024-11-17 but still it has not been backported yet umm...

What do you want to backport?

-- 
Jens Axboe


