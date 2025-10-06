Return-Path: <io-uring+bounces-9897-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E5CDBBCEBD
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 03:10:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3C8818945F9
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 01:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27F78199E94;
	Mon,  6 Oct 2025 01:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fWBos7Gh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD9234BA37
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 01:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759713052; cv=none; b=rQzHIXYt8CUG2lDjfzWtmxhiE0QTNaX1FOSVGX2YUpgDlZE19mRzd2watDYOPrkYJc0XhtwMhnzHZo5HHCxOjrS8Yofp2xfoiD7Fkzrvo/CsBhCffUkYhcYfcUU/b3caQoGuB1yRAvFmdaP+CddFwTv7ZJdWeWjh1xabqj2qkaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759713052; c=relaxed/simple;
	bh=fBwpXv4iJDsn00f8jYRFI7UmPCmqZL8ZFKuvyYMfAx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VA97gAt84F4wcd34H8QgMyCj0rOFEy7+QNu+O7SLWr6ebtqRwaDPcBPSQIjmEWPpL8pTpvzQet3CJwdORBSfvs0kZTc/yLMBGxYvzPmCUGM5YsqWaYclWO7PK/q4I0NiL5ZX0l4/tGp1UWZHBuKTmIVENukIZS5G2eK6jVsmazY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fWBos7Gh; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-425911e5661so16255055ab.1
        for <io-uring@vger.kernel.org>; Sun, 05 Oct 2025 18:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759713048; x=1760317848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0rrmDdEv4QomqbfXYE2IZWi8y4TFwIZDkIWfsBWlw70=;
        b=fWBos7GhFGFxANFyibBgpVaH20lwBSu3Un2tVM7ztRxnE6YZsuCux5kj0ztbosYnwh
         nvkaib7PkdIliDfirG+TBFwxktvPX2sz9oIPy+ExZroQNqKcazlimZKYuwUY+6Mv25Fl
         D7/w/tVPSqnXaRT5Vhz94lipSbL0AuG5pGgBxF7nGCgLRU6VXWEA2UhQCC1ia9sDf554
         PRdkXrrgxRS3vSYiiBrBHBFhXS1z9f63LAIZObqoIzCFAu15azrOs3GwsjpNA0WQISYa
         2HSIElzTnKV9sM832uRhUpYEF2U/hFygAENAA+3Y087Sa85Fcy1YjIbppV74CQ4fU52J
         di9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759713048; x=1760317848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0rrmDdEv4QomqbfXYE2IZWi8y4TFwIZDkIWfsBWlw70=;
        b=C1slWeMCUrnIhjVw1ymwrLeCu7A4+xo0F6Oud9Ezn1HU+zi3jw2/RmzWfbbRwYNWSK
         52qT9XbhY4fPNSj6/M3IXSMHcpaS4oUwQz94Nb9Tseu3qna/lSdYdg65i2Ok7hOMQyW0
         m+Ix9o1OFYcC2Ktignzk/pegy1yafvbHW5J7Zdc3BtR6qU7g3GdiDJN3n1UEVM05DKKh
         3+PAYrkcMqRKmiO4Wr2z/qH2WiME6owBj42uJrid+lXmXyNsPLIognUMD1g+Ss2Dei4Z
         OMtJDwiSkKnQrLr78I7UxhRiW6MkvifZm0vF+tVuS4QydU/dbkhkY3ghUKm/4vC6eFEn
         uJJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxDj1+ORiMtQK1HVEbRy8L4ulqlXMAFm8+9eoxVOp9snZO4IEG/fjVKCxg0JFI2Gp6rREx63gG9w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyBX7zh+6QVGGxPgNBhkkOP+HWohDF07YIDdo2sWpMKrE4o6shZ
	Lk8WLAecqQacc9gk77/TWvNkbLkUqPSmxlQ1f2aV2zVrLerUyfRfGa56MA3SMSlD1RFoydbxosH
	+tszDhzo=
X-Gm-Gg: ASbGncvan7fETqM1GErFRXSLdJQRGwx8vvgKrNcZMdeOOW3GH3lbxlLU2S/mvq97z5p
	znjzBuK/k4xqxftHTX8bYBKtixemk4OytBIpNZF0jXahVO8UWvCCQQBywBOmnw+FPIY6mWUof3x
	zQvBc3YsHBOceHgOWIPdSdw0s8E9N2K6Fsfe/PIMylbAW4aACHLoeYKoBbVmqo7BWtMjY9gZA+4
	MkoOj6wvvDa9fwzYhP4bQXNEcGKtlo2R4LfJewdxNu1khZDLGOaz/kg7o5M7XlNPURWxABavAlX
	e+zhlfIt1bU5jVOFkUfXuUIcDb/HTONjLlZvPhxf1YdUYEuK3xyAQcPq2fzPDiIYOY+kc5PJOvz
	X3zytk+RXSoBpojblojsDLjJOHGRgQWss3r4J1JzzthA+
X-Google-Smtp-Source: AGHT+IEazvBbdBQWYvCykPkvgCDXRdpqfFoK+fRUdR3XQGzhgBeee3ap4vdhkAOG7beRj6wMB/YfiA==
X-Received: by 2002:a05:6e02:1543:b0:42e:d74:7252 with SMTP id e9e14a558f8ab-42e7ad8f8damr161587895ab.31.1759713048395;
        Sun, 05 Oct 2025 18:10:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ec4a68fsm4452024173.66.2025.10.05.18.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Oct 2025 18:10:47 -0700 (PDT)
Message-ID: <0d0b2f46-a7a1-4468-b38b-30482de9f154@kernel.dk>
Date: Sun, 5 Oct 2025 19:10:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005221045.GA838@vultr155>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251005221045.GA838@vultr155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/25 4:10 PM, Jacob Thompson wrote:
> I made two typos in my last email. The cq *tail* was 10, and I meant
> to say the cq tail* isn't zero which means I have results? I'm
> planning to reread the man pages but I feel like that's trying to find
> a solution in a haystack

I'd encourage you to read and understand liburing, even if you aren't
going to use it. That will tell you how to reap and iterate CQE events.

-- 
Jens Axboe

