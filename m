Return-Path: <io-uring+bounces-1289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B338900BB
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 14:46:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7E2261F26594
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 13:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938EF7E788;
	Thu, 28 Mar 2024 13:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RrKCqQjP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB2412E1E3
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711633521; cv=none; b=S22XSsJTWy6cD91sdWo0yeysp9lCRzzoaGlpWxpDRPNLD9F9BnSxm7vqZrVuskVf+cYvAIWGN2q5EVxZYBZ+zUW+0QKJ3kfSX670hwxXeCaqbDEbe9iRyHO6pIhyHzcFgxm3I0XXC0itfZ198udPmBtRv1uQZZEhUAv/YXX/BN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711633521; c=relaxed/simple;
	bh=EyjZUO8MGHJTRBhfsQFKXA5witIFFpfPfz2K6T5IQDg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p3QiKw1xJT78QOqB8spjFR7u03u2RZrtTCQQiuPS4q265du9UAU+47Kq+wpFMx6vaMcH3dl2sIpqbwziXBdIirDZ5K+ofqOdZb0j8ODOPPypn5M8z/J2by+86vQX2n/7HCGcZ6Z9M+hFWm6R2guS0obT6RyAFyWzEaOaxgoKwxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RrKCqQjP; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1def81ee762so2209665ad.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 06:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711633519; x=1712238319; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+dqSuNsG0c6zW0OOJhlFmu7xMI/K1tE+LBQRR/4CT8=;
        b=RrKCqQjPjhMSXb9/rHr38NnThGdauj5jcIXsCysSCbG58LnaIB5BUtkVfnGzE91vsw
         M2fB0HjzEp3sUfPCVbGVtOp5ZLdFDMSIyDmcBWiuLUdYMd+vj2eQrpBx0KxzhJC0bbpO
         iyvAbul1GaF/i9PM6uvacWlfhdWO6klaUWGqq4HTZpMJ9IwXs1sXgVn+42U+T6dLdg6h
         nk/5aTzAq6f6DNUnYEry4T7FBldwta7YDrBoClLhTty9asHd5xEXI0d4upr4E/5byRLL
         AJ1utHRRcMQU8XqmsRCSGYuXIpQeMHXOCWKXfVLYzXsgpdlnuXAV4EfDUSh5XEEmKOmH
         IZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711633519; x=1712238319;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R+dqSuNsG0c6zW0OOJhlFmu7xMI/K1tE+LBQRR/4CT8=;
        b=Dswr1tyTIswKCAyp6/M6K/EPeLMlR/z3TA1nNVIrtq0esE5RcPjnYQQVM6FJQzysGz
         TIcrof6vcJYZEnyyKTQOCUk3K9rhWZpll8rkt+RjQJbMbYB2/iSfkEzwsBby7pCXURI1
         Ifxwi35WlQQG2iZSdmxsApdOXjz2iZ116wIy9Ic16CjohNlZimHZaRkIbFGy5bndpH8J
         puMcLHvOiR7bauhEuuj3A8sJd7r+TtPiKbNCDzWXsuL+OzJDDq4rF4o9j9mxUe3O5hSs
         VlJx1hOjuQAq9k+Z7PkTC1oXRU9rQASLC9sNj4N7CGn0sZFo/OHeN6B0geEL4qOPZQXi
         2hjQ==
X-Gm-Message-State: AOJu0YytNE/5FaTgn0MvOE63hprkigkxhCsTMPfx4tarX2Xrt0la2MQk
	O8A+YOEv5+aYH2qQlg3IVRggT3D1whpgrwErMU/UwNZYvVazd0wQKWqrIEGM11pfz6ooNiz2ZoH
	+
X-Google-Smtp-Source: AGHT+IE8Kk88OQlWC/BwBbWVWK7mNrrf17dLoSQTUhKYaEcJz1cw9LWwpDUF+3ogm7mCWpyLshPB/Q==
X-Received: by 2002:a17:902:c3c4:b0:1db:ce31:96b1 with SMTP id j4-20020a170902c3c400b001dbce3196b1mr2820420plj.6.1711633518697;
        Thu, 28 Mar 2024 06:45:18 -0700 (PDT)
Received: from [192.168.201.244] ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i10-20020a170902c94a00b001db9c3d6506sm1569875pla.209.2024.03.28.06.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 06:45:18 -0700 (PDT)
Message-ID: <ac62cdb1-e511-4651-bbc2-a840b0d2dcc6@kernel.dk>
Date: Thu, 28 Mar 2024 07:45:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing] io_uring.h: Avoid anonymous enums
Content-Language: en-US
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240328001653.31124-1-krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240328001653.31124-1-krisman@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 6:16 PM, Gabriel Krisman Bertazi wrote:
> anonymous enums, while valid, confuses Cython (Python to C translator),
> as reported by Ritesh (YoSTEALTH) .  Since people are using this, just
> name the existing enums.
> 
> See https://github.com/cython/cython/issues/3240.
> 
> Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
> 
> ---
> Do we want to sync with the kernel header?

Yeah, usually the kernel side gets updates, and then liburing syncs it.
That's how it needs to be done as the kernel side is driving
improvements or new features. So I think we'd want to do this on the
kernel side first, then sync it back to liburing afterwards as a follow
up patch.

-- 
Jens Axboe


