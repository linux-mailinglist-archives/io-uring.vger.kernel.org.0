Return-Path: <io-uring+bounces-9175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A04B30045
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 18:41:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3CFE71BA480A
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2852DFF19;
	Thu, 21 Aug 2025 16:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2cpL3TDY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13345275AF8
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 16:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755794288; cv=none; b=DhuIszkCZxELgkQWwxV21xpQ+yYEvVvcGfDtSDa3Bb3uyJ2SEdLHZiunMv6sDywK4FR+AoYQGb3jivBsRuy2bUCfrCamPvdDv/g41rOOVAaNhrx8pMPIIDAhT/gee6P4N0VzPSTU+/I/Xxj3KwuTKUsmyYsLtkR5d6iH21817m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755794288; c=relaxed/simple;
	bh=uxy58DQXeZYDDG8ImRPiNfDzU2CmOymjeHQCVhkJKS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ePCqCUg22VqHYYR68LyVNQgFDZuF6nZVXVdpdDB+5q+sauDPLOj5Pgg7qQlhfDHYYyn890al+BPcbTanEcBAYZmItQjX7fToIHubpSrsWv9UkKu/YAf6nfOWL/B6VF0gZq/HW1glnDDoNXDh6XONwcOjzmFInUnNvbCkhRyrpyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2cpL3TDY; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e6666a4f55so9791575ab.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 09:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755794284; x=1756399084; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2ID3opT42QoxPRfR6t1H4nWblzjw3O+CvLTSPw+jTuA=;
        b=2cpL3TDYaQ74sCgVuHBz0XqWQP/OWoGQgwU5WaoYMd78VBRe+m87rBWDIWvbeFMjK2
         n7jSL93xurlK01G7M4y4NJFvVA59mlC1Z52PaMdgPW1RFTArc4sJE/l1WK1oaG2Iuuze
         cVOu8gXJlggBDSB9p5qkJntWnRlqErmr/zWV9ofrNzcm8TZdPEN1swcmNf2LZe1eeX5G
         kzT/OBWpwmSEwz2Sau8Tps08UEBivUEDsHmEYZ3TdgMX28OXpiwFcjtOM6py6ID4B6b7
         Qc4vgNk4Or74Cgugk0r54fMLRARqQW0/SzvNPR0C/89QoRD91Zfnkl+pWhVHi2QQnDip
         Ve4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755794284; x=1756399084;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2ID3opT42QoxPRfR6t1H4nWblzjw3O+CvLTSPw+jTuA=;
        b=K9qwujrESdCdxHdYueo4r7WyLrVkLYY3ck9aDPVJxKsBAqbdQ8FONDw+eOnIP7bv/U
         qj2w65/XW5kbWxzBZsaaDQWGRW6/ib359H9cv+RNpgujNFSUVhe9y9/+TH7Gl+8u8cta
         DCCjcE8G3r7MNzaRohtL8c0OlVKhLCvpOrm9mOb+0mbiqC1NeinDpiT+d3SlIRa8xd58
         SFqjXY1LAChmpp/CiRIjXrUUnGZ+srYgBx7cgCK2oXc8e1vnm/c7d6/FHVeZWPdE8qF9
         1HTkM4obENaIUlEXLIxlw8lm/B1EF3J+t4dqNNM2lun6siJpQ/Te9VTEKjhUYRRNWBK6
         mVsg==
X-Gm-Message-State: AOJu0YzE8qO8UA+T6OGYHa0ymDldXagsNY+EtIx6bLSYerOFgYnMuAs4
	ET8bbA1lHxk5uPMsw8iZnmkBWQmjGtfhx9dQ0U2ZdylGi/zxC7sOsHj82VKjnMc33U9YcwzJAiR
	A0DHH
X-Gm-Gg: ASbGnctGFzZehYGXgL5B1C6F5xOVUdt+0hqkiDzbBNzqsAvCYaQ3gWqGblrYoxbwZuF
	kc72vF8KcD6jMqIafOvDx+DtVFpp5pLtP2TIXxnEhUW8i6slxLetFA5pTsrpYcV5TCftqlNy9+X
	m/N3+OlznbxIr5t19VY2La+LVTvpZ/z8DJGwQrGDbpWCIZfcWcEZeXOQPlHbyWBL9MDJGHnaxN1
	gxvUiLf+VRYPwICDYPvRRJC280NCUAbQ8j0nMMlsAl0Lz7JAe/1olrf2lExm2GimHs9tKrxyze6
	DEp+NtWxErmzKfmAP+9VfirFJTxr59axQ0/883UP83Sg9Avw5ajUsKfsqPqxDA46WUAdkv6ltjA
	/n4Ez/RYodErrepH2Tk+Fv8wKc4RznQ==
X-Google-Smtp-Source: AGHT+IHriD5+i0a8mPP2WVYEHmdh10riRTp5Zv269wJpPJb9/ZloNxGywPlUW8+rMInstheo+XMaeA==
X-Received: by 2002:a05:6e02:1fea:b0:3e5:7437:13d3 with SMTP id e9e14a558f8ab-3e9225088femr70725ab.23.1755794283611;
        Thu, 21 Aug 2025 09:38:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e6836fb3c9sm16166335ab.51.2025.08.21.09.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 09:38:03 -0700 (PDT)
Message-ID: <9d40cbdc-59a6-4bae-b71c-2d024de7e8ed@kernel.dk>
Date: Thu, 21 Aug 2025 10:38:02 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] io_uring/cmd: fix io_uring_mshot_cmd_post_cqe() for
 !CONFIG_IO_URING
To: Caleb Sander Mateos <csander@purestorage.com>,
 Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org
References: <20250821163308.977915-1-csander@purestorage.com>
 <20250821163308.977915-2-csander@purestorage.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250821163308.977915-2-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 10:33 AM, Caleb Sander Mateos wrote:
> io_uring_mshot_cmd_post_cqe() is declared with a different signature
> when CONFIG_IO_URING is defined than when it isn't. Match the
> !CONFIG_IO_URING definition's signature to the CONFIG_IO_URING one.

I screwed that up twice... I'll just fix this one up in-tree.

-- 
Jens Axboe


