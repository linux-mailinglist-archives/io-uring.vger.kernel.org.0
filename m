Return-Path: <io-uring+bounces-8715-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6F5DB0AA30
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 20:36:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4079C7AE460
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EF8C2E7F25;
	Fri, 18 Jul 2025 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oUK3fxHj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833DA2E7BC4
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 18:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752863774; cv=none; b=YEGitIs3f6cGJBCOuZ4xVefVN34FzYMkTanoh5g6+8i9f7B94BytV5ZpjEJwwTxVu/7rSoMSK2neH7dDXAgML6hPXwJOoSQCYidujR9z39J3RWVZwcU3dDyFx8wOt0aPv68UgLEQV6vNE8i9Wb9ICl/GZXz10Db3tdJPme+3eB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752863774; c=relaxed/simple;
	bh=5qlQ+761hn6OrnIDwaSrOkWt9c8/47BkXB3UXwRLQss=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J3Vo8fEVlOISd0mo8bBKIcGPX0XJCFlUnEJtuOy7UW6OQubrZBaiOXanW1AXfswL3KOdXUZ1j5PdTC++85s/klpGuHw//c0+Apal0dgpbgB+Jyu/vERLCbFxyuIfJfjTj2+Nsubgy0YXSi28/0nuK1vmx9SHdgsIHuSt4GRqnHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oUK3fxHj; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b34ab678931so1772002a12.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 11:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752863770; x=1753468570; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7YHZSIH4QXyQQjmvIqyrjSbplelhoOzEiXOXvbUIHNY=;
        b=oUK3fxHjQrvNljhNQYlMGlMMbdSzoi0ax3lVkfmRynN9oXzvbwYfsc70R4z/4MJowO
         JC4lXcIu5NMSmmiosi7y4hiEguGlxoQTSn85CuMp0MUtG2Kb8lgcEEvTGxXVzpLSTtbw
         2obSk6KPuB8Rl12vbo+hu59JlxZbSpZnaxkwzBzdq+JXkNQ7iF6tS5vosuWBjDduf5xB
         95X8YKpvwhbr7S4rZD9OxTopoPu4/MuL86tlcs41v5KxgPHaCaag1GM8HeODko46NWhF
         f1WsOC22pGhwwQEZPCIT0uB91WXVA6emw9brkaqG7w8wBg8A0QotfLmINl61CrctcmCx
         wEUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752863770; x=1753468570;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YHZSIH4QXyQQjmvIqyrjSbplelhoOzEiXOXvbUIHNY=;
        b=AvSQhq+/7mm+UtMR+poext2v6DnnwDLeVsMt3TG9lNQpXNXRyqZXt4nNkJnC6OdD6V
         LpOPOhVhl/URh83rdaYEcVWzPWK26QUTpBr6LaDI/pF880GXthpdQNwepIgmXHB19KH+
         EkjoGdxHwq80AwsBhCHi/jtremZtVFIkYpmEsA5VBYZuDNcVx1K2uTD8ykGFfm5P/g2j
         2LHz1zmf6zXhR0a7+z2nPXcsvq4xyu4jzvxgsNjLnTHO46Gl/a9e+GDiAj8T+vXzGl8/
         wka5mO12n4bsWjSeiVHRofmG31fy+YYrr3f8MGQjiFiOZzIK3afWYSbQaTC0w6QXuD0l
         VGIw==
X-Forwarded-Encrypted: i=1; AJvYcCVVCvqTehIg9PZcktaB6mrCLnH3XAxcE5DfCR1wNabwWDVzgxbEMXiKcVSE/jqN1EKpU4ebwn2EuA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzP6VOLwQLzeACldBdxa95LT73EaECWt4LtveUIKubCnVJnkjVR
	e5PyMHdi3Ir4DbXYgh0/QnqWUsRgfzQ23a5nUanPfWvNfEw9K2AsiMwXL0K5GrBr3bU=
X-Gm-Gg: ASbGncvXM22jezf9VMUFvyae9arf0VEE641kIwj0IbN+EwEMYMacoGcoMQ4GkthIR8Q
	rgIERKLh2WUhkywIAdJeaLBstyjJ2UcV83MKX6mGqsxkzejZJiuPtkqR3DS6fej838JY/gfBmyq
	/LCKeXGqSdzPaSlEdJDWdDIWunS8mMjb1FFDM/SCTUnrMbggEaseo5i0oiEcRQ8Wzlf19WaCUCQ
	DeCE07oZQLo9+8F14KvvI+uV+SYnCZBGkNl+k1tAHAbzyrSJ4uChYGwIO7PFRiVtRTZR+aEFOeB
	aFq0eV4LFSmW9Vg5jqzPrsEepj2G6sggrx7cMr5xPl4EEocXDS6sgtSo+HzYwiHHUxN80pZkGh9
	/Ecfqg0XlPCFq8az+hoQvV/CadMtUwcJjLIi6qn5BptUwyGbf4QmK3ZST/aZFQf9QmGg=
X-Google-Smtp-Source: AGHT+IHNjCZ1lF5IxEcSK7Q336xvA2JqN/FhLb91/xqIHcN1SLy4r5JEGGmXyt2l3qmS+/4JJPp6Gw==
X-Received: by 2002:a17:90a:d88c:b0:312:25dd:1c86 with SMTP id 98e67ed59e1d1-31cc25c5ab0mr6395789a91.18.1752863769794;
        Fri, 18 Jul 2025 11:36:09 -0700 (PDT)
Received: from [172.20.8.9] (syn-071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31cc3e5b404sm1687820a91.12.2025.07.18.11.36.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 11:36:08 -0700 (PDT)
Message-ID: <72eeb282-2e9a-4c06-ac5c-54f226a8500d@kernel.dk>
Date: Fri, 18 Jul 2025 12:36:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
To: dsterba@suse.cz
Cc: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250708202212.2851548-1-csander@purestorage.com>
 <CADUfDZr6d_EV6sek0K1ULpg2T862PsnnFT08PhoX9WjHGBA=0w@mail.gmail.com>
 <bb01752a-0a36-4e30-bf26-273c9017ffc0@kernel.dk>
 <20250718172648.GA6704@suse.cz>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250718172648.GA6704@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/25 11:26 AM, David Sterba wrote:
> On Fri, Jul 18, 2025 at 10:58:07AM -0600, Jens Axboe wrote:
>> On 7/17/25 2:04 PM, Caleb Sander Mateos wrote:
>>> Hi Jens,
>>> Are you satisfied with the updated version of this series? Let me know
>>> if there's anything else you'd like to see.
>>
>> I'm fine with it, was hoping some of the CC'ed btrfs folks would ack or
>> review the btrfs bits. OOO until late sunday, if I hear nothing else by
>> then, I'll just tentatively stage it in a separate branch for 6.17.
> 
> I've taken the first patch to btrfs' for-next but if you want to add it
> to your queue then git will deal with that too. For the btrfs changes
> 
> Acked-by: David Sterba <dsterba@suse.com>

Thanks! I guess that works fine, it can go in separately. I've queued
up the rest.

-- 
Jens Axboe


