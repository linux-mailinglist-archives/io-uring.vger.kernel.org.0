Return-Path: <io-uring+bounces-2506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7933F93059B
	for <lists+io-uring@lfdr.de>; Sat, 13 Jul 2024 14:39:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F5531F21AE2
	for <lists+io-uring@lfdr.de>; Sat, 13 Jul 2024 12:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0EE3130A40;
	Sat, 13 Jul 2024 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Sx9WZETm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD72212E1D2
	for <io-uring@vger.kernel.org>; Sat, 13 Jul 2024 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720874345; cv=none; b=X8q4bmbdJbtuH+bBUtvZ8T27aF8FoFaC2lcH0LIB4U1QWKOsnI3NdpADJoedpUWt6CeTSDe00aw68nOYgDaE7W9yMGcOofkKRY48k3r1umt6Kus/LdEGge6L81eHqtjhw4nB5Wqzw19gC+oQIXgNYMesUCl+lQZhAVsGtcFnGe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720874345; c=relaxed/simple;
	bh=4+95kjVIjtlcszRvAKuUnMD1B3e2E+wMO/ciEz+40YI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WAMhHRGrEZP7zROmoZsjDpkM2xBVZb82boWXq3dljYKLizKWWxMr8y36Gr3F3ZFkhf4kUtKB2u6i/b+i5oKxj4jmBBMmj6vOUTnG42DKuFE/ibIhfwFt1eEvWyWC63i4QJojOjX8fpVLNEOSPek0BHYEBR/4wq+uYXkdlhHOJDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Sx9WZETm; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-584e3442410so489154a12.3
        for <io-uring@vger.kernel.org>; Sat, 13 Jul 2024 05:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1720874342; x=1721479142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u8hkhdHmp9Cd52s/KNQtC+KUQpLlcR8ECOfdL5ZTCiU=;
        b=Sx9WZETmQE5lwyaVI826BgQHQfwXxae6v71Vms9/wQMcmLGeQl83xqFcHDGLw2o4F7
         P5gE3h+JIuJWOVAS0SBiekb2JVV/8ikPv9av/WYBFHU53++Fk/gY1R7oz1h3Z0L2Qg5U
         2dE2fWbSmDz+s50Te0P+sizMDQMH+p9jMSbukWGTYpMv248jVQAuFKE/4PYY82jbxN1w
         +A84n3F1n64McNEISGUVFUJVZzq7vKlrBqpZRa38Rv8ND1+DfZmKrNA2DPQ934vW8ZDy
         UqmzMBqLDKy/DOeIMV3li3BxqonynEh0lqP8NNmQ0FtOKbUmKa7juilKWaCF5P3qj/fM
         D0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720874342; x=1721479142;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u8hkhdHmp9Cd52s/KNQtC+KUQpLlcR8ECOfdL5ZTCiU=;
        b=ebHvnVfVLPQyVieW8SVPjI873oyZ28cY9683gmH12t5EpxVE1WVf9eAZNrDIrZL4eK
         ZeRlphnUfr/w55FAz95abafn0mi0t9eBUSWnP1GnXiyNnCQmDEiKdx39aFPH0XCCpU8B
         JWadt6puMWqGthbzsUCnvwt387iZKuifdd3rW3ER/Rek+1PYTvXmdAN3Idwwlf+MWf0g
         7MgkyCNEYeshWfalUkyGUp1xyE2dIwpj+izBPnPhRybEPpgXO0yhQVVIUb1U2ei2vJNU
         LUPKUVrJob868nH7Jokl6QsOc/HFeqM6bI6WcfQzzxmY7L3igKiqWU6iIZ3LNuTxH3PN
         d2wA==
X-Forwarded-Encrypted: i=1; AJvYcCU6BC/BGIaV/OJXbrtrB8lE/NGmWEoFvAAVarJQMV0xVvUgSuRrmMMo0grZJgV62SymKcuMFoVCQNFojRlcfji1J8dXtzHPJ9I=
X-Gm-Message-State: AOJu0Yxv/D3I9XxAo1V1G/+PVtgntkN0LFV/q78b7havza19CRsI+i6N
	mSi1GBnY9a90NwOWOtvFNxHaApqk88l8Gzx6p402k3joCzKEg10HINOaDMqCwSk=
X-Google-Smtp-Source: AGHT+IHyCFkgxA6T9OzJ7BZMsLeqWafRuWRco2VTLlq/+AX/e6UKF0v+jmeU9JYYH/Mvg952m9fn6Q==
X-Received: by 2002:a17:906:5a52:b0:a77:af07:b97e with SMTP id a640c23a62f3a-a780b683d00mr811317666b.2.1720874341628;
        Sat, 13 Jul 2024 05:39:01 -0700 (PDT)
Received: from ?IPV6:2a02:aa7:464b:1644:7862:56e0:794e:2? ([2a02:aa7:464b:1644:7862:56e0:794e:2])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a79bc820d52sm47609466b.214.2024.07.13.05.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Jul 2024 05:39:00 -0700 (PDT)
Message-ID: <7ca9cfc8-3423-476f-b768-8f089dae140a@kernel.dk>
Date: Sat, 13 Jul 2024 06:38:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Check socket is valid in io_bind()/io_listen()
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 syzbot <syzbot+1e811482aa2c70afa9a0@syzkaller.appspotmail.com>,
 io-uring@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 Pavel Begunkov <asml.silence@gmail.com>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: linux-kernel@vger.kernel.org
References: <0000000000007b7ce6061d1caec0@google.com>
 <903da529-eaa3-43ef-ae41-d30f376c60cc@I-love.SAKURA.ne.jp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <903da529-eaa3-43ef-ae41-d30f376c60cc@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/13/24 4:05 AM, Tetsuo Handa wrote:
> We need to check that sock_from_file(req->file) != NULL.

Yep indeed, that was missed. Thanks, I'll apply this, just moving
the assignment to where the NULL check is for consistency's sake.

-- 
Jens Axboe



