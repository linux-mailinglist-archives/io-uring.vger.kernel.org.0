Return-Path: <io-uring+bounces-449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3A28373A2
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 21:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EF271C24F25
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D84540BE5;
	Mon, 22 Jan 2024 20:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hJEpAkpD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9AD3D0B0
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 20:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705954965; cv=none; b=YHtS+YKlA/cpAdH63G4+QXJTjhM1jKeMOOyCUgoHdMHloU2zMaTm8kEFqHFpxFigMZWwmbVBkkPEugIdw/YPoT5fsyoz1svO2PClvPveaI9Oo5WobvHf054Auk74Ovkp3cHfzB33ctcxYmYGZrjx+9toYZUguHH3fyp0r4m40Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705954965; c=relaxed/simple;
	bh=mL549UM8wmJuR4Q7vaz/DvYB8gAFxlDQcu/OwqOJZco=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R7NhdoSXdjWXpJggL87x9vdEr/VFgojhjUZhf3UZATNi4ayoXSl400CBO5uzUZbpX8li2UxfNq1to8hARQrdprW9YrtM1lMSw90aO5RynY1FchTj0OjFBqz/FGsiIX6a+RkXegDK4C8I0EvZP1CCaM7JFHBBCihIoc1BCD77NJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hJEpAkpD; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7bbdd28a52aso43917339f.1
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 12:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1705954962; x=1706559762; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dQ+we5MNlx5zWy5WnfPnvBeRoEDg18JWV6yHEXRXwWo=;
        b=hJEpAkpDiStSMA70PUUbNcEhSalPI6ZC+uOTmk0zLStJ8b2C5rc11F/JnhYcfaHGCh
         RzqjDr24D60IRpzK8SAGAnWZeWORZ4LFJoVpRFtjtd9hFD8mAc/anNTQRLkLuT/VdR2e
         AVOrvEs46OQDojeXc5exZHHhj7+nfRuaQEuTNa8KQ6V4YYR5Q02BA5KEILg2DuLF3liQ
         CgFJAhmfZ9vd3w+JzT/Rbw8OX5sXrmvACJhI2U5QwHn3wEiwlhn14DCP5wDfkobO4TG0
         iusyErh7cPOAkSApe1phelfYySnnu0VpGI2sd7fKM5VXTJqkO8DQL3cl7L0Ssew35uWB
         afcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705954962; x=1706559762;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQ+we5MNlx5zWy5WnfPnvBeRoEDg18JWV6yHEXRXwWo=;
        b=vToXwKi1LDhAdCnGZGImt/QtxIgnnCikLk0mcMnMSyk197vZb7jTsb+j+jtzNnkh8Z
         e8C+ZROBcVuUSGBVkiPwJlXPhqKrHgfN+Ag9E2sCKO/VXLgoOp+xgXAqEFpW4dADLEXH
         n+soUSniEx+DCB5GlkX8O/4NFdnTylylGy3k9fS+d3lQCrKTrkPgM2oG6FsC9OdPWUXY
         G+Jih+wKCYJjneLMobxsM7VUtpvdIroH2F8ud03bnyMeYqcTDD9Y8aQlRPGjP0bKELla
         oerW7gCNCpY2tH2S+n/U++8oY36TOZ+CbRhN/XZLYKctauLjva4+3ASdHUuLQRk3QyUF
         OC8Q==
X-Gm-Message-State: AOJu0Yxc8Ax7jVgagvTzENMJCHZ0BydLxQU+8T0sFjuSY95SlgaMWPLv
	lGjjYMaJ7QKn9kJ8aEgEik6Zv8kY6EpGVfECaeVYSz6ONd2qg+z/MiQ/nULEAJI=
X-Google-Smtp-Source: AGHT+IGn7bfy4LObTVmHjeZTD4dVSDoTKjIUNmdyu0vwKdF3xkXGosQDzvQbt47R8ogUrKlt7V5A6g==
X-Received: by 2002:a5d:9518:0:b0:7bf:928e:71cd with SMTP id d24-20020a5d9518000000b007bf928e71cdmr4550845iom.0.1705954962641;
        Mon, 22 Jan 2024 12:22:42 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r5-20020a056638130500b0046e8d86f2a7sm3220074jad.57.2024.01.22.12.22.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jan 2024 12:22:41 -0800 (PST)
Message-ID: <ea2ce488-779c-4ad1-82f0-285fb2cfddcc@kernel.dk>
Date: Mon, 22 Jan 2024 13:22:41 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] io_uring: add support for truncate
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>,
 Tony Solomonik <tony.solomonik@gmail.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
 <875xzlw2iv.fsf@mailhost.krisman.be>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <875xzlw2iv.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/22/24 1:12 PM, Gabriel Krisman Bertazi wrote:
> Tony Solomonik <tony.solomonik@gmail.com> writes:
> 
>> Libraries that are built on io_uring currently need to maintain a
>> separate thread pool implementation when they want to truncate a file.
> 
> I don't think it makes sense to have both ftruncate and truncate in
> io_uring.  One can just as easily link an open+ftruncate to have the
> same semantics in one go.

Yeah, see comment on the life time issue with this one as well, which
is avoided with the fd variant. So if just having the ftruncate variant
is good enough, that's solve that headache too. And if done like I
suggested where fd must be valid and we -EINVAL on sqe->addr being
set, you could always add truncate by path functionality later on top
without requiring a new opcode just for that.

-- 
Jens Axboe



