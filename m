Return-Path: <io-uring+bounces-8161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90EE5AC91B4
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5112A3AA441
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:37:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 354A022D7AC;
	Fri, 30 May 2025 14:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cBHOJZ+O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1647A2288F7
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748615888; cv=none; b=bINVn5TYq1rR0Wcqbmt7+FxZvCFIHtonH96w3H3zOKynefC1eHv+BzjZ4C4+U7P0e3WHih0eNJPu+8JCyaHZR/C9FwcZIHG05wrkLbXVdF0T1zm6XfLivWN008J+vC7DmZPgM7buaEy6eGbOtsXbzjiKBtNeGPu6se0g7EEtRJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748615888; c=relaxed/simple;
	bh=JpxYbOAdFVK+TsOk9ZLf7ThOZ0hf38z09wDaoh7bprU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AjYb5t+oHnM7IThMRAfmylZoRrIDJ/Pfply2qN9A2fSlmYIUsv9lWNnyvE/iUNMFKQnpnRfHyQr+/UO5btCDyAsBOcMlxypxhTmmK0oTZamY1V1bc9SWM224kVgz0UsrzR8TUVJv++46ZI5V31EJZKOunphGLiqy6E2BZ8hXq7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cBHOJZ+O; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3dc6b2a8647so6870075ab.2
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748615885; x=1749220685; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9izi2TjfdmSg9b9E+TB8ofi/7gNztWlJ9mKdG6DgYBo=;
        b=cBHOJZ+OxPlDmprTCnpNSzO21MoLJ7X+yVexYr+MmGRNviBTkvZw4sMke/fvg+2w21
         j3G1VkjybAvVNhBPfIwIydkqFcoQhHiMpWFkNNn33myZ08jiHj3jhGL/Bqn0kWtjMR9T
         usUOs4VhqRvp/zbgyLD5YKtT9B7opdeyMF0yvkV87z0ZkDyIJvD5Zcv1dRPfhTnSOGR9
         p0jTGdCWXYJR1/PBZxWalEN662Cp+TRfX/RJK+Qw5TrfgrjIwpmMmtJWZBP+z5dZkR+V
         JIkBgMf/l5L8igEwfgV11/t+AuVLD13w7h2tdloghpBahAH7caoV+G5qLczyaIcl60gj
         RTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748615885; x=1749220685;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9izi2TjfdmSg9b9E+TB8ofi/7gNztWlJ9mKdG6DgYBo=;
        b=I0eKjNei59tNRpgaFjN+gM0w9ogaNEubZpnlzEYqDi+TlkbsvVmyWiA3xbEgLjDvNo
         zLLxGU3/quLMv2Tpup8FxTT4eIFwFtyQsLnBn08nJZCNq+YsP2o829/XlWLhhLoLcxHo
         AhrfdrCXmtCSCCSpS7ZTisZU3VnWSOAQycIZmime60IvyxAcwzpcgwZq3KYxEmM6G8zO
         G+rRpJ+f8pX84BwvDJ9QtDo2zPQwEZfTh6p4UFG606Xie5LNh8YGOGtP/wLUseLAUoQG
         6PDPRmf3ZhcUbipt7Q9TC/pHMh7PIeU19qFxx63bGVKfruEbWtv3duATP5ff8VFDn0ty
         V+7g==
X-Forwarded-Encrypted: i=1; AJvYcCUtaozSI00z76hZi8xCz1AsTPxT3uY+9YU6sp0+HuVM1dRLG79FoyDUJkKyGxPa4vMwJZ7d2VYCag==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3GzVa/9q/YomWArgrfUNGFoQ2ZpH2DUFLZ6w5ursC1lI+illx
	gLfm8tIGlFiZP5ddylzwOFWp5WISx/Yq/4XGZUYEu3EEgHuJuJ0/kxCM41pKGHSZLlvWotDiasK
	LHITl
X-Gm-Gg: ASbGnctXUCplbpV/ALGizrJhYwBwEWVJXH38cbmRu9blXb9P6J6MGpWKpznMIu9Dmbw
	pBZFAEYqlE379z5BPTtVWwwaB7pSEcREJV/81s69cKaCqpgtYeqJ5RfT0LFlIvGTmT5GEOn4gW1
	CabXblmj1T5bQnwX0r1KBRqRMi4FZNC2QQXbMqGCcojEoWvx5+lgOR/axX0NkjdwVLMzxI3UJp1
	JsAlI3ICAqDL1BmRjKCnewPNbmO8kDeNYZ7d9cEEGyYmp4zXpSUo01ku2hWZGCGgh21xMqDJvXf
	M9yRT62xt/SFktE9B7k+/k+fD5BdnjisAXHRB56/AplDND4=
X-Google-Smtp-Source: AGHT+IHuwX8rt/C8SgcUZxBTVOfjripFotj2aDxQEHzGwNK3pgFqxCcYCVN3Y4SZcp/j23Bra325wA==
X-Received: by 2002:a05:6e02:4416:20b0:3dc:8b29:30bc with SMTP id e9e14a558f8ab-3dd9cc15926mr17110615ab.21.1748615885006;
        Fri, 30 May 2025 07:38:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7ef6ae3sm465294173.109.2025.05.30.07.38.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:38:04 -0700 (PDT)
Message-ID: <5e3311e4-cdc1-4262-ae88-354effbabec6@kernel.dk>
Date: Fri, 30 May 2025 08:38:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/6] io_uring/mock: support for async read/write
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <6e796628f8f9e7ad492b0353f244ab810c9866d7.1748609413.git.asml.silence@gmail.com>
 <792793b0-fcee-4915-afdd-e13cb4d59a53@kernel.dk>
 <876cb4ad-e674-40ec-b1c4-928638198fa0@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <876cb4ad-e674-40ec-b1c4-928638198fa0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 7:49 AM, Pavel Begunkov wrote:
> On 5/30/25 14:27, Jens Axboe wrote:
>> On 5/30/25 6:52 AM, Pavel Begunkov wrote:
>>> Let the user to specify a delay to read/write request. io_uring will
>>> start a timer, return -EIOCBQUEUED and complete the request
>>> asynchronously after the delay pass.
>>
>> This is nifty. Just one question, do we want to have this delay_ns be
>> some kind of range? Eg complete within min_comp_ns and max_comp_ns or
>> something, to get some variation in there (if desired, you could set
>> them the same too, of course).
> 
> That's left out for later. You can always invent dozens of such
> parameters: introducing a choice of distributions, mixing,
> interaction and parameters for polling, but that should rather
> go in tandem with more thorough discussions on which edge cases
> it needs to test.

Sure, that's fine.

-- 
Jens Axboe


