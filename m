Return-Path: <io-uring+bounces-8211-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF3AACDD76
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 14:06:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0E8C3A5CCE
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 12:06:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55A6252903;
	Wed,  4 Jun 2025 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HaSzR+Kt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A6424C664
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 12:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749038781; cv=none; b=ahDFJk7So4Uia/RiOCoNAMiKMpXAii2y399tIykO6SVD87J/rNVusj+VhiKtvUS1OjK3Vy2ESxatQBLt/EocEGkoy4PGzrbTnobWWOwt7gUjEiAI76h7yMQt4UTZbP57e5bKxQ7PtfXxUb7VzZ5R7rBINS0/bgxILEhK0rKMxQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749038781; c=relaxed/simple;
	bh=li5pwyVONb0p1T3scAjyEFhggCPBma4Pk32TqAkfTAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MmqNfrk4jNz5LwkKV0GNFjLvuRMgQJnp6vM3vGsORF8ihEwIXiY6sdsVPIDdHfUOqvykf8Bpedo+wR7uaZNMxGF+cPl+yuhxZKMym+Zzj1YD/M+viKdcBaNlA0zBLQ4c2bISsiaqQwSPRr2XVR8LeR0NWfCf4FxEM2iBq6jXvho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HaSzR+Kt; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3da8e1259dfso51615795ab.3
        for <io-uring@vger.kernel.org>; Wed, 04 Jun 2025 05:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749038779; x=1749643579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a6ZvHr1OPTYWMtt+54ZBLynXyScHxJZGo2+u+HC5+rQ=;
        b=HaSzR+KtmU+o857HOdoGYCFe56t7mKe7E8Xw9mao9oViNGYmuCEsrd9gcODN+ZFvdQ
         T3R/plHXIy+ZwOJb5pzkX3rpnssid9vGBQ/JaJ7ZjBQC0CFyY1hIIIFZxkYbguEmUNDw
         dTiQxPr4I8S7xOLV1+4dJj77aqxrbKIM/nkV6GspuuzGOMFpTMM01C4BZSzL0JITvjLN
         EQsPBcPhmaDWwz3JxCPzXe89UCMDrIoqKCec2uM+gKz+phmGxQxIJKuQKnv/rNxcIcu7
         w8RsyCWvHH++7A9hIVVg6RvtJUlY1L1oV8ih9YlFoKSxZPF+HFuWNlhKI6kT8W86YE7x
         +npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749038779; x=1749643579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a6ZvHr1OPTYWMtt+54ZBLynXyScHxJZGo2+u+HC5+rQ=;
        b=SkOqhej0QhRWJnj491GgCH8EbbtolnOPv5vj5ACoI3r90X2OuTvqB2SQruVg6oZ5c6
         CKYMiKr7pFOBJT2KIedwS96Fy9tWyr/6MhTArnkEd9l5+fYF75cu6/V61OXN6FY3JBhN
         P51QxIghCmKIsH2f7rBM4FMW0DsbU61i4WgqTGWnstoQpUP9jqjrs5MQM7zB2U0AboPH
         jA1SEt3eiEKXJdmPEAN/mEadtj86wX6VJEYWiUCIVLP8FlVAefpASWg4cOUNpGoMVp9/
         08RTO46A1KewfHSpfQfFc2a1HQnjbZ5+1QNw+7hxfid7VH6TbIKDZ6wxJEHD9nuWHIU2
         JtFg==
X-Forwarded-Encrypted: i=1; AJvYcCW7zCMSlqyptIeeVfcNG6Pc5Gcy1D3EWALSFwKKlbGABk9FGBkLin0O3jGOgPwvwKa8yGMBly1jqA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwhjuXZm/ZEXfNNxZH8sc7hV9kd3nwfsLhVhqGfBjIt/jc40+En
	gvm0s8KL+Y1diupz4Mkqlejo/s2ppcCsm1MqTaclsj6wXs/PPiQpeO1/P6sKd8uYCKM=
X-Gm-Gg: ASbGncu1j45myc7DpqXlUqZMHr1rIKt9chzEWc85dp6nt7YcsAJ+W1aP5USZ0CfV5xs
	764cFz9BdGzT5RaIduc2zskNNoODF3Xhg8QnRnnub1NrpkzIGSswy/g/TY8A3GwIU6t4MTtalrV
	dtTcmVRhVRYCg6rY0k0qCsm3NmwCTDV8XyhoBdMy7fpWTGzejarB3WxGYhM2yD+I0qTdr4tyrmZ
	4x00CQnrTCowuOf9/dPBuNli3EcGoDUb3KAN22rssuENnJA+agYdXFxsBR+5zRtA1H2kkRRZ903
	qKVq/RhF97iAZkgg0klAOJAqrEqWZruCJ5aAYJB62QJztNbiYOiu9b8gEis=
X-Google-Smtp-Source: AGHT+IERu2kBEnpUUoO2G+cREFMrm34H66z+ZO1gglYnZDp46u0VyUBbpCENmN7DR9q1seV7bZ5DBw==
X-Received: by 2002:a05:6e02:250d:b0:3d8:2023:d057 with SMTP id e9e14a558f8ab-3ddbedb062amr23719195ab.11.1749038778937;
        Wed, 04 Jun 2025 05:06:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7f22536sm2781898173.134.2025.06.04.05.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 05:06:18 -0700 (PDT)
Message-ID: <1cc7d36f-9bf7-4aa0-a974-35fea28a7f49@kernel.dk>
Date: Wed, 4 Jun 2025 06:06:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] io_uring cmd for tx timestamps
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc: netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, "David S . Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
 Richard Cochran <richardcochran@gmail.com>
References: <cover.1749026421.git.asml.silence@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cover.1749026421.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/4/25 2:42 AM, Pavel Begunkov wrote:
> Vadim Fedorenko suggested to add an alternative API for receiving
> tx timestamps through io_uring. The series introduces io_uring socket
> cmd for fetching tx timestamps, which is a polled multishot request,
> i.e. internally polling the socket for POLLERR and posts timestamps
> when they're arrives. For the API description see Patch 5.
> 
> It reuses existing timestamp infra and takes them from the socket's
> error queue. For networking people the important parts are Patch 1,
> and io_uring_cmd_timestamp() from Patch 5 walking the error queue.
> 
> It should be reasonable to take it through the io_uring tree once
> we have consensus, but let me know if there are any concerns.

Still looks fine to me - is there a liburing test case as well?

-- 
Jens Axboe


