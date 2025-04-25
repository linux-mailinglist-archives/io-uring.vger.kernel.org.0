Return-Path: <io-uring+bounces-7724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AF5BA9CAF6
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 16:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C1654A74B2
	for <lists+io-uring@lfdr.de>; Fri, 25 Apr 2025 14:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E25F253959;
	Fri, 25 Apr 2025 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IRLx0WQ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB7D253941
	for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745589615; cv=none; b=ZrF073KPbC51k2Fe5/0PUfciE7XIP5k3h9eilRKksknl3w9GZ6NCSuBS5SVFYydLXpk3Ut6eeqOC3CcpKJXANpTuFMjDbD+KW+zE4jMDT8oShJ0VGZiSs9qnnMYlNB4UI4YLE9nx/PdeUPLAKnMTJTBvN1MeYJOXitXX0ga7g1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745589615; c=relaxed/simple;
	bh=+cWrpoHw8LOVL9fRa6jfKvfFntuT3rraxQ0d2Vt4Mso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TnI5qMwAUl6MgseA5zEJMFiR2nOd8gRwK9UFB7ZCKq19ZjKzqqgItssURKwkuLZpxcxYxtjOJijInjpMZU2gpyLr//GIt6vnWbx6m0yVzmNTSAJU7Xd62VqTyJ/vBqN2obsZ0PJWrSiKjv/heAFbGqwZTVQ1lClbumgNi0uM1SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IRLx0WQ5; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9eb1eso243271a12.0
        for <io-uring@vger.kernel.org>; Fri, 25 Apr 2025 07:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745589612; x=1746194412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GiXhauMYLfRCYeqRXCiBKTCJaD37A0W76kjFtkqjTlw=;
        b=IRLx0WQ5jJ3GqJWYVkP+FGgzojTKCimXKTAPGf3NdQYSxnyp72MLSYyr5NNsolu3Xk
         3dtn7UeGpJR08XOImEEo9xkorAl+K+n1fnkPqdhgmbRwWd/AirpWV461eMpgCqxk6R1U
         MGBQanyZF6Ur7KpbxLXFZvByEKd0L5eVGOuOndSbmFOenhaou+rlu8g4ZEgwg3iO/hN4
         RspmOlE2z3BtpIFCWWymwn8iQQLBtWGZFHA9OImSeoxwXtF6zADMOoRnKSX96f54KDmF
         bnGwdfbd77xcEHGmrf0mOyNKUblQ7JJ3bnXwmMPnf8N43QqhWpBC2GE+TwndQHz+h6Tn
         MmWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745589612; x=1746194412;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GiXhauMYLfRCYeqRXCiBKTCJaD37A0W76kjFtkqjTlw=;
        b=USNpEQxbrH4WbTXl8oe30D3D24AvjvjXL4/m7CAviXSi8Kzl3NuRNHSdJnbcztzjKr
         6OQCVNukj9ozbhxnveos0YZuquNWGyammbYVYalAkwdZB/fH3ZtONqGevJlu2tb3oB02
         HHLqHMXkjOR1uEIRCOsHF6+jbuV3DxSpblG8xIMlARL2ClXfny9Z86jZA6M8X6tcRCNF
         JFDulvhD26Kf0yoWbQlxWWwblfb90jSA3oD7Ht0MdwlzYvr5Cy8Bw3hydQi8DCHDHG9B
         dYrut5ALCeFfybLVGOU2f2PJ49xirBV+r0FaRTgZfcu/NRymtBvtrTWnmAJxDVNzEyQs
         cktA==
X-Gm-Message-State: AOJu0YxYypYhnnCb735nauENvCZ/Fa0tSjeK/FzYMo0nQXobeG07wzIC
	7EmuBq+w5cmRg4o3Qr5JkF5MTRJVF/6sopDdHYfHxVW/WsPAQLy2WewKYg==
X-Gm-Gg: ASbGncvtWismfvBA5Wdaf49UHBdpKUgaNA9UlkRA+Bty64klArT9LmF1NplmCN1Fft7
	HWoVgYFAqq0soEzN4eHvUAx6UWW4AZxLtdJkmiMMqJc0T7v7nsmVJ8UoLZw22v/w/41GYfJUzzl
	LNENn+ITa6paXmxHkLKTzIYR63ZQXhWMnyV7tlHDdq+k2Uw7bSMPC0+s73wwAQI5TKZc8eUjfRC
	GNt5agDxcxOTRnPwqeIMwDYNWz06c+yejPJFt3vzFwynIT7vUIOvMqHVTp8T6peXLDOJ2BIJqhi
	+tHgF80imkJA3fzcFwME3Ca+dBQDnsyKsG2xwrom7Qtl9v2MQvFV
X-Google-Smtp-Source: AGHT+IEU/7zphlXNRHogcsdEgXR2A003KS7dzfzed/Ij++/Tl1pO6fiUSUYHdiufP4090Rkn/NXLEA==
X-Received: by 2002:a05:6402:210d:b0:5e0:6332:9af0 with SMTP id 4fb4d7f45d1cf-5f6ef1f8249mr6005726a12.14.1745589611529;
        Fri, 25 Apr 2025 07:00:11 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::44? ([2620:10d:c092:600::1:9541])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f7016f6418sm1356397a12.40.2025.04.25.07.00.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Apr 2025 07:00:10 -0700 (PDT)
Message-ID: <b8bcb087-21c8-4304-812c-ecaaf2b2c643@gmail.com>
Date: Fri, 25 Apr 2025 15:01:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] preparation for zcrx with huge pages
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>
References: <cover.1745328503.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1745328503.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/22/25 15:44, Pavel Begunkov wrote:
> Add barebone support for huge pages for zcrx, with the only real
> effect is shrinking the page array. However, it's a prerequisite
> for other huge page optimisations, like improved dma mappings and
> large page pool allocation sizes.

I'm going to resend the series later with more changes.

-- 
Pavel Begunkov


