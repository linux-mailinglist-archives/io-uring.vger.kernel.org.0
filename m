Return-Path: <io-uring+bounces-8713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D123B0A8F7
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 18:58:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2A2E3B64C1
	for <lists+io-uring@lfdr.de>; Fri, 18 Jul 2025 16:57:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3062E6D26;
	Fri, 18 Jul 2025 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dSHZiGBu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F4F2E62A9
	for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752857892; cv=none; b=Zg3siV0wbvEKFQIYkpALD1/mLrxWPB8Brsh/mTqhpL46P9x94Bt5gK9TudUiL2v+e/G2309RLym7T8Ztr9MzMA+ojvWN6hD93v6/g02Hp6a/A+nVn9zfK6RmPd7IatjTqLoIAupK19Ky5C69UAtuV/RJMtUezTy0pnXXjtHkZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752857892; c=relaxed/simple;
	bh=VLW3UWQLxGRdbGgQdSEaWhEmJKomiEjyniwXZIeWPNI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QSPoZvXa9YoLvdFJTuH1DXMrnli37dPqJobVpRpDF5vGM23GytWt7u1vwq4EsxmqBAD/Evg5tBunlGrAtZXD5U5xUQuSc7lLn/BMwgJLivuxzdDCADzhX3kSir64wgmX2r3JeIY0CdUjGwHXDwgjlwjbLoMULo6QzOPonSDkzps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dSHZiGBu; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso2190170b3a.0
        for <io-uring@vger.kernel.org>; Fri, 18 Jul 2025 09:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752857890; x=1753462690; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nIjnpXR7kFzmkgbsnqn30ikPUW7z/FzWNSDSSmsQgxI=;
        b=dSHZiGBuWcQwqvuP04xKJ28O1+13I/OeKSA6nUCS5k0S0krUWhmwGEbOsdhAP4/DeI
         J5QTHCEny63CAkflis7lXL9hnh+McWpKhJPOm+2Rfb2UvWTkOfZddWa8fUxWBsFxg1h2
         llguurF+zpeMeMbG3yJ6DQb0XMCyooSyu120VRjzxmos9thKIQVPIZTjJkYHh/OhsGZz
         SYSj3N5BRkCroSoJ2BYmE3+s33viYuuZoBDq0CA/r9C/sbXvuuvUsB4ubjgDh/Lz8w1G
         brGGFHwo9O5xD0fZBckw7teVx0XwYdx31Hl19s4h1UbIfCDYB905OH0+nxNAsNQNO0gI
         FDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752857890; x=1753462690;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nIjnpXR7kFzmkgbsnqn30ikPUW7z/FzWNSDSSmsQgxI=;
        b=nLoyniqCnBkdo5jfrYLG4mxlVTEy5yvbVso4fD6fvfG6aJPNzmqvIUttklViMV+bs+
         a+T1aIhjYzYLpFD6t33Ul39rhcV3BZIxxnyRL9wdZgQ9okZ6K020x4/UVE7/DDF4HCam
         cAsQKCQO3QTlWprCQN6X/MYynQjZKJvbDStPlKTST1mMXJT/CpD6A1PCuwB6EVLZG4b/
         hLJAymGY2MNSx7A8S+Dh1ERw7vd+rjl1hAasP/O91pvy1nR2q9k9v29V8LvSOcO5epCM
         EagWlgOPdrlMsytYc6MiUWz1hhuiMgE9iLcgw808YGRgGnf0QOSh0LfOTQFR8OJUUGjy
         Bcow==
X-Forwarded-Encrypted: i=1; AJvYcCX3+DOeSx2cGfWVAG0OAP4ftkVgaIMXZuchXaXyyeAYA1W5JgUQJkA4IZN4kViM7TJ9ia300ozgtw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ2sTDOg538FxU6HKWNX3rZpNmWQyfrBzd0kcbI6xrzfXPo4B9
	6iYSU6kaRrF2aFLgYjC0JY4NDa2A2ITDvqnAMgOuK3YqG3xf0OdCjX5eit7CN6ZJ5UI=
X-Gm-Gg: ASbGncvI8X+qOhpGeJBSeuvTHckkjhwRPpujrphYaWa2NGHEMAj1z20Q8PgS0Ozwrdv
	z6eKXSf/wD39bg470KfatthTvnlxZISwKCSDREPwXCU5qMJ6VqozrOSf8To7m87OEv+2DREGJqw
	4USB0k40tr85vV816ARr58Ntqaiz50+kUhvE0L7WbMAaHS8EoygttSOz4vKHlxf5XgppTZi40Tf
	jXhWywcRf3xDC6AwPkc1Bn6fOiRNkkhqnanonK59zH0bezP5zK2v/mkPHSJ6w+6vzUn98XMhJdF
	J6JIuP944rQFmDvD3sU5o0LonoVvXALdVXn415S5oyZWM8kXhwZXKRtAE7/L1DYiKOUZ04gmrIF
	VVts4+HFECqNLzIy6hS5hMC7pZSgPOygd5UOBJcuZsxnndI3hVWBa5LnH
X-Google-Smtp-Source: AGHT+IGSYEopSk3acBGxusn+C3aQwEH7Y9k5SO3YHjLM61xU8Uro/IWUb/xfLi/OwISpnyV/yTpN+Q==
X-Received: by 2002:a05:6a00:10cb:b0:748:ffaf:9b53 with SMTP id d2e1a72fcca58-757242790admr14294927b3a.16.1752857889825;
        Fri, 18 Jul 2025 09:58:09 -0700 (PDT)
Received: from [172.20.8.9] (syn-071-095-160-189.biz.spectrum.com. [71.95.160.189])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759c84e20c2sm1551781b3a.18.2025.07.18.09.58.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jul 2025 09:58:08 -0700 (PDT)
Message-ID: <bb01752a-0a36-4e30-bf26-273c9017ffc0@kernel.dk>
Date: Fri, 18 Jul 2025 10:58:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] io_uring/btrfs: remove struct io_uring_cmd_data
To: Caleb Sander Mateos <csander@purestorage.com>, Chris Mason <clm@fb.com>,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>
Cc: Mark Harmstone <maharmstone@fb.com>, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250708202212.2851548-1-csander@purestorage.com>
 <CADUfDZr6d_EV6sek0K1ULpg2T862PsnnFT08PhoX9WjHGBA=0w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr6d_EV6sek0K1ULpg2T862PsnnFT08PhoX9WjHGBA=0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/17/25 2:04 PM, Caleb Sander Mateos wrote:
> Hi Jens,
> Are you satisfied with the updated version of this series? Let me know
> if there's anything else you'd like to see.

I'm fine with it, was hoping some of the CC'ed btrfs folks would ack or
review the btrfs bits. OOO until late sunday, if I hear nothing else by
then, I'll just tentatively stage it in a separate branch for 6.17.

What test cases did you run?

-- 
Jens Axboe

