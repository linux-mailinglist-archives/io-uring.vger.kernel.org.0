Return-Path: <io-uring+bounces-7635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F84A97460
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 20:19:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 495CB17FC0D
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 18:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA30296D1B;
	Tue, 22 Apr 2025 18:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fFI41pZM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4461DE3D9;
	Tue, 22 Apr 2025 18:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745345989; cv=none; b=tfyVdJWp4TU9/UifsfyZBu+KYkG/Npd3U5ElhsbnI3g02SLbyLxN1szcMmXAq4YDtUtsT1mxFVN204C/1JZFHHcKEZgLa9r6ICeNglEmQN0LYlTxghR8UrkyH8SBS06y91Z4DBalcZlj5qNMS84hO931QOBzesUtVjQrLHAi1Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745345989; c=relaxed/simple;
	bh=8wYCXgZqpbTDarUW031W7MRIpH1sLDyCBxxD/Ri5fVI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SvjIBfT0r70IrK53zYIB3mj1zPNkZ+xQI2flM3Pqqu5c6G8o+teNkogr18wsueL37pDTsRnbLW7IPl7ad7ium3LSk5OqPRfA62txIcTyO1rcexfGRBTNQuQrIGGK4nbeP/ucMeQz1z6wZ25m/rOzdEHmdOnZqKhSRDjo2fHukxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fFI41pZM; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-39c30d9085aso4112410f8f.1;
        Tue, 22 Apr 2025 11:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745345986; x=1745950786; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4wU0CuSU6YOeYRo+NJ/4ERb7AGDM75DMO3ccWS5aBc=;
        b=fFI41pZMhvq9311eYU4XvdZK2X1BiSZ1kDpnO5pI2gDW8zfhCC0yLORqDWQm+cVbwV
         4FBBoAquFYU8e3xZWbSfYXS6qHEPNsmdaCoGa/Saj9W1n2npjclApBTCMcHB3jfZBN0d
         VWb+DIdeQmgAcXdSDiX3XGPUq2jHa5OiEnzNItTNmj2AehqvZYog1cGUEhyETtmlywch
         59SzQn9A8hoTCNX7njFf8HsC7FOGJKj9BMehhy+yesUQtbMYDouPVeB+Bjymw01lj9+P
         qwkZVntm+FXp6RFLVWmwYDPFGL3RyWiXPbEfxy0XrcCPjMxLAgSpIYjNHSJcPdmJccqB
         j+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745345986; x=1745950786;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V4wU0CuSU6YOeYRo+NJ/4ERb7AGDM75DMO3ccWS5aBc=;
        b=nG5GkK3X1xxyvWyRJ5BdeDKu/Cwd27DAf5JB457CiekWUmTAju3b+LV64z4s2bql+h
         F1XlVWraXqz5XjWmxc+Mc/78ktXfLCrtRn8rpxVCBILUZ1eq57q3C6Akpk9pq8uJvMDP
         q17h3yDyIUHS0/8QJR+Ka/u6T3B0sNNkZ7vRmJxm4Faos4FCdi/uG0Z7F3OlR1iHFAUy
         BXje57bZHi0hHfknjo/tp46KNKHWgCZSPBSkXYAyRIp1RsgAlKgP5TceFYaNXWE21xs6
         NiCqps4HKxoBpOgoT3dofi4VAyG5SaY1W4/DoZgttL/7Z0570dlO84ZVj000qzJhBhMv
         7SVA==
X-Forwarded-Encrypted: i=1; AJvYcCUalTr0SqmQ+M0qZkJ+cF4twPxat8QzHRVnGb9K36KXO0j5GSfDSIwvgBH2Ifi3PRhTyqcCZ1xlfw==@vger.kernel.org, AJvYcCVr0v4E/k5cN/LtiU66QTL7KzM1cO2wq4UDAmocoJi8zXvZMt1b5/bYIPqcZD+iPOAm26v1TG53EBuCCGZG@vger.kernel.org, AJvYcCXHL+z3FYAO5kIOgLOr8Dw5WBJ21Qu49RFPVRFvQorpzfAR7Ip6QfhwnqUFyByBInXeiYtx7FvDSByjlbBsWkcx@vger.kernel.org, AJvYcCXQlEO2y1AZ2dLVvsDgN1IXq6h4z5Jus6HTODNJj1+kVVjABalKFfhyE8WQyXj1bO/zRiafMO7uSdGm@vger.kernel.org, AJvYcCXj97CHAyEOSRGYxLpeuXvSiIA9uT+rIZq8f9sC5ZvAH1VGgfwL11ONLtqCeX1i/MFNvRis@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr3f+2OSHGdggGyghjI+XMLYZgX5sDXJkQlYLsQaIJwZIE/V3Y
	4M6eAR4aepdqRTTjJmRJVAu/QoN6XZp2v+f1i7JrcPSZusr4v8Zv
X-Gm-Gg: ASbGnctB1REMRlqbKwxTauF7PbUgBbMegdUSNH8LVyMyo2X1Pvx2gqEe1BO3nlryH3R
	mt+6GCe7s+0dUVulcYLg5b30q7MkJJK1k7YpAyCGcQDzseQvxmzd90NMnuYnnHM6qGwY8dE/WSF
	cTkPH8/2YBgJvCYCr8zEo9T7Wb7/MPSgXU1sHfjkEytdfLiD2qYYpB3Qfea6WS+IhKAFgWikJXx
	3S2b1crxehpHPkiT/rrPnu0waFjwtR/TZJ+SkYpUR6u4yFW7YL9JCQUNAajqWEorZegib1N9teF
	DQ/xifZq+TbRiPVKbE1ThvlzTQhVoVBDbVf5jLsEY9m+6E77
X-Google-Smtp-Source: AGHT+IGsGcBMmgVltHKkfzj/5mF0Ny9f6RgMByhyMlB833FKD6rDdwvWOUJDBJsAjsbBce/iJtRETg==
X-Received: by 2002:a5d:584e:0:b0:39c:140c:25e with SMTP id ffacd0b85a97d-39efba560b1mr12910171f8f.24.1745345986104;
        Tue, 22 Apr 2025 11:19:46 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.235.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa42082csm15911065f8f.3.2025.04.22.11.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 11:19:45 -0700 (PDT)
Message-ID: <957b74ed-f29c-4bb8-b819-af4e1168d6c1@gmail.com>
Date: Tue, 22 Apr 2025 19:20:59 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 2/9] net: add get_netmem/put_netmem support
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>, Jonathan Corbet <corbet@lwn.net>,
 Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>,
 Harshitha Ramamurthy <hramamurthy@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
 Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>,
 sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>,
 Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-3-almasrymina@google.com>
 <484ecaad-56de-4c0d-b7fa-a3337557b0bf@gmail.com>
 <CAHS8izPw9maOMqLALTLc22eOKnutyLK9azOs4FzO1pfaY8xE6g@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPw9maOMqLALTLc22eOKnutyLK9azOs4FzO1pfaY8xE6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/25 14:56, Mina Almasry wrote:
> On Tue, Apr 22, 2025 at 1:43 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 4/18/25 00:15, Mina Almasry wrote:
>>> Currently net_iovs support only pp ref counts, and do not support a
>>> page ref equivalent.
>>
>> Makes me wonder why it's needed. In theory, nobody should ever be
>> taking page references without going through struct ubuf_info
>> handling first, all in kernel users of these pages should always
>> be paired with ubuf_info, as it's user memory, it's not stable,
>> and without ubuf_info the user is allowed to overwrite it.
>>
> 
> The concern about the stability of the from-userspace data is already
> called out in the MSG_ZEROCOPY documentation that we're piggybacking
> devmem TX onto:

Sure, I didn't object that. There is no problem as long as the
ubuf_info semantics is followed, which by extension mean that
any ref manipulation should already be gated on ubuf_info, and
there should be no need in changing generic paths.

-- 
Pavel Begunkov


