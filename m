Return-Path: <io-uring+bounces-1923-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DE41A8C8CF1
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 21:46:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 665E7B23386
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 19:46:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADC4E321D;
	Fri, 17 May 2024 19:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SspqRzlK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D915615CB
	for <io-uring@vger.kernel.org>; Fri, 17 May 2024 19:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715975169; cv=none; b=q8s/AcyYQO0CGGGETd2fKDIrV6IfBVXvOI8e23l8bSL9Yku6Q0jA15Sxx52JHMaEzvxuFOTyjHOZ7p2GpxUjwCu3caE8tUfxxTBKU7oPAAzW7jdfG9ddcgGX2/KUA9cqDfZ5mdCpEY5SZj9wvw0kvwLdbtIzNxY1iBHa6aSz+eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715975169; c=relaxed/simple;
	bh=6VszPci37rkiGg2K2NgOGBxlVd8psdQe83L70Sxqzrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l2GhxDJobkJ5OOQaAei29mnS3TBmzHzNpAzjYrVDW+kpigWOoOOOvaHjOLjMDDkntEuNgh0AfbegJ3Z+hP3MeHSpDZXdLb7wbY7s4ijuz1OoPDqv6GPAVTWTGPstTXOwkQAmeijZh4Aa0XUvTqNuWl8q9Qq66PR0Ik5Q688/Who=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SspqRzlK; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7e1b8718926so18224439f.2
        for <io-uring@vger.kernel.org>; Fri, 17 May 2024 12:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715975165; x=1716579965; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=avVWBUeBq7oiw5/HWGNt5PgEJGwHVmDOCW/yCYO+oKQ=;
        b=SspqRzlKvtHz7vqyX/ALVy1ErZRTBLdzXJHsSjL1P36P3xHeY+JmnZFoDQ6b1Dw2Qb
         VYtiJA9nF5KNfQQti5CNZodUjDlP3eeCwAQI8NrQEvOZC9WDGdqskfCG0zN1Nib7oG7y
         ed2+LyOWSNlFbYRszhH3EXg3tIhSgnzMTEsKNEosdpcCyVbn+AQLqu68WZXpBTXRmUos
         FTidgx353IjhwpOHBgD5I9CPUzprZY1z/MNfXmosQc7hkHMMFS3aHAVWghh/NJHC/V9m
         ozalmBcTDrOUk7Jl/NsRGlrFXQdQH6D9uwsLMvnZW0S77t+c4HLVVCEVBlr6ZHSRhzfq
         U+9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715975165; x=1716579965;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=avVWBUeBq7oiw5/HWGNt5PgEJGwHVmDOCW/yCYO+oKQ=;
        b=dKtz9tqA8jLhrkovN7FreHoAxO5UGE//efvfxE5i6BBdkZlO3Anw7EjDbgWsiQ4aRr
         6CYL9v1o17iigjsxzNaGnKbOvjARp6Xs3eVj+ytBQwIu9QleAmw45NkdJEeLMuwn43UR
         G7njYo/pdkMpxmzAIKqIgy4OoW6VGyA5HckrkBCdVgEMTOA8mpNNzoO7ow798znkR5l7
         VWmX9eLJWRUONGDTzgeR4DibEUUTUihgOuP6pyE5uPmk5dxkje0J3VUeyCdsRXm7YWq8
         EeaGpjV82UHV9DwBTsWU6cGCbgYxFASvydAl8H+dHd5VSbU0YCCb8Gi8lj7PV45C9zuY
         sVEw==
X-Gm-Message-State: AOJu0YwAauXVS8Hkm4cZevTcacZwXrFNpCMIpjRPCtIN4iJsEwNMeQdb
	77MWcrBd0yxDMlkpT9K89cpfE6YeYOCmpfLQAmNEbTTd/WhDdWcYX5RAGe9tq0A=
X-Google-Smtp-Source: AGHT+IH33rF9FRPzHsg0tfJuRIjXoLOabkaYLxIT5yRzgsKsVbvcIHoSa/yryE0mbIqr88rVXNyV/Q==
X-Received: by 2002:a5d:8d88:0:b0:7de:b279:fb3e with SMTP id ca18e2360f4ac-7e1b51fdbecmr2225306939f.1.1715975164945;
        Fri, 17 May 2024 12:46:04 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489375c1482sm4833227173.85.2024.05.17.12.46.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 May 2024 12:46:04 -0700 (PDT)
Message-ID: <7c203170-49d2-4979-be84-72c6a7cb191f@kernel.dk>
Date: Fri, 17 May 2024 13:46:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Announcement] io_uring Discord chat
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <8734qguv98.fsf@mailhost.krisman.be>
 <f7367e15-150f-4fbb-b026-73d9407fd863@kernel.dk>
 <87y188te9j.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87y188te9j.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/17/24 1:44 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Is it public - and if not, can it be? Ideally I'd love to have something
>> that's just open public (and realtime) discussion, ideally searchable
>> from your favorite search engine. As the latter seems
>> difficult/impossible, we should at least have it be directly joinable
>> without an invite link. Or maybe this is not how discord works at all,
>> and you need the invite link? If so, as long as anyone can join, then
>> that's totally fine too I guess.
> 
> It is as public as it can be right now with existing discord rules.  It
> can not be made discoverable without a link yet, since it needs to be at
> least 8 weeks old for that, from what I see.  I'm looking into that.

Ah ok, that's not a problem if it's just a time thing. Once we're that
far down, we'll know the utility of it anyway (or lack of), and we can
make a decision.

> The invitation link doesn't expire and doesn't require any approvals. We can
> safely place it in liburing documentation.  I mentioned it is revokable,
> but that is a safeguard against spammers and needs to be done explicitly.
> 
> Let me know if you join. I'll add you as an admin.

Oh, already did join.

-- 
Jens Axboe


