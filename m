Return-Path: <io-uring+bounces-9993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21639BD96EC
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 14:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF1373A6E81
	for <lists+io-uring@lfdr.de>; Tue, 14 Oct 2025 12:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3AC288C13;
	Tue, 14 Oct 2025 12:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SIOhET1l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DC22EB85B
	for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 12:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760445945; cv=none; b=K3z+Suu1qvF+PJa9a+SCUuEcGzrNEmF/Mh7I/sO2FD9FWDFgtnWvas0TzsQLuNuG+0v8uW1+Lwo+yGWcAGNVMFqvb4BgSCt1BNJV3KnPyOZEJcCShvM2hjo6GmCk8ZIpcEuGJD9HW+4KBZVAkaAdT1rAkPcFpiu5cqZUKibZckc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760445945; c=relaxed/simple;
	bh=4xAZty85ZHdvBE6Q6Ju6E8/SyfTuwcvhqmJQ6fWLs54=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MML+WKkH9DF/h8FasccFhmzSIp5NwBwnK14GrampOYYbRhrFMLMBMN4hnnXbfstpzopAPQg4b2qQtHT1L3e/bfV1w030MmtEey+D0DrxBnrAWMzVCIRftYeshsGY3B4pUfPh2lKnWAoJcIjyzfD5bkv8AIoZWr8OB8eXCjuW9qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SIOhET1l; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-46e430494ccso30470395e9.1
        for <io-uring@vger.kernel.org>; Tue, 14 Oct 2025 05:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760445942; x=1761050742; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t+s+MnUCBJ5Abbhdfz+BBRkABbDhDMVmHDHwHoH2l6Q=;
        b=SIOhET1lP1CVEl97faPGO0VQp8rByWy78RyyTQJ62a5gycXaEFN4W95RDO+019HH7D
         U9fSHg0ptn4JjIuGHDt23ae5jN9cs6Lf4wx02pqBFc1PEyn24REtWb36TUcLn4KLvq2X
         ZCSuti7V+4r+5smtVUQHuN0GQLO46+F5ChOtFDmbXMkbT7VPE0X73lfqU3zN7rVsPOS2
         JTMoQpeedNZkxx8ITPlZzzAOqv3vZS5No6nZsD6PpJ0/vwdIqyMYTB+dZvKgXvNa4KYE
         54rfafm2j6aUCD/0SeLxGBXweMg3Wbq3nqEmP9cry2nfD9U4Rb7UAilPHO43+3utCJsz
         mV7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760445942; x=1761050742;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t+s+MnUCBJ5Abbhdfz+BBRkABbDhDMVmHDHwHoH2l6Q=;
        b=NqvrIc0WVYV3daEpjuT/yXqyZYDOGFQD3f9cuLFFp26h4Vzqd5eYLiU+oWnhFy4aAv
         wtEC+PUqL/eKgxkD8sYuOy3XCnQYgHO+bor8eH+muMJnC9BLJJiLtmoi7NY+H6wcJWNY
         LiWziOoNhYtfXCwnvgyPNwQCF6uAUorJdw4bRKOiPHJhlZ91/zVL3x/GWiukkJqBta0Q
         buq3DLnxyu0+cOwD5hm4lfPym9zt/YZ/IHwRyo3YPAYkwSdI4hc4AzkkLr5+FHvoeI0L
         CKjJ+ELOdCjTptd8AS+z78Ih8w4x0luUm8t9w+eqwt+8FdHL/7OPjaXujRsUwVR8a9DZ
         VF+A==
X-Forwarded-Encrypted: i=1; AJvYcCWRUMrGZXVKK+umvBpJzIbku67/FK6tg502MQh2ZFnro6RYmn194+INS3Lu9NUgf8Skg+FrBYhmMg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh/V13++rY+Q6DCWjDAZAGnZ0EhaxFAr/pvU4CpsF+hk5tF81Q
	dvz4r/kF64V16BZd7Kosx1jQojnDioREpJSBfBykEV8I6XrMcBSDc1WK
X-Gm-Gg: ASbGnctNxlrG7CfY/ZXxaiFCuWAfpCPW+EiVfywan4+h5qWQblmwbwsF7A2rc2oyzgF
	Y7qhJOE4br4B9wLzytdCt0khcaggs+kxhYdHN/R43Fd5iRN9Jvnm36CLnp7GzaeyEQLOs5XnB8s
	dyIdDBOwVITuaxSW9LnOI1VKLhNSmbMj0nTwiTThw+RaQo92tC0SHo0+/j4dgi1MYD67CBOQuaL
	q8GzKGTW7gkiCAE7MyUauea3X+c3/sqhrC/i3j78O1ZpGqzjj8UGe0Hn/KldKpfRJtqbpsrJ8aN
	h/5RtYDHzgOMGJlRj392jrAthKn8WwMt/OBqo590ZYfU245LIHW1RX8/SOOLREo81KgBLTJk/e1
	gBDiLIZyL+5i+db/f5wkS6DCu1++1p3Mm57TbjUPmEUOm0rflYw5G7DbH2rLdhzxPKkwH5kJVQw
	v671+Zb7VQ
X-Google-Smtp-Source: AGHT+IG37XYlLrmKRzsVTbT8x4wG0Ta4s90KjMR3qbRk2A+e9jHNkHgI8r+1AkdRhNxcKymiD3ZRzw==
X-Received: by 2002:a05:600c:c162:b0:46e:47cc:a17e with SMTP id 5b1f17b1804b1-46fa9a8f4c8mr165749265e9.1.1760445941678;
        Tue, 14 Oct 2025 05:45:41 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7ec0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb55ac08dsm232559785e9.13.2025.10.14.05.45.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 05:45:40 -0700 (PDT)
Message-ID: <0ef2009e-2593-4b15-a96b-512c1dd30151@gmail.com>
Date: Tue, 14 Oct 2025 13:46:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 00/24][pull request] Queue configs and large
 buffer providers
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Donald Hunter <donald.hunter@gmail.com>,
 Michael Chan <michael.chan@broadcom.com>,
 Pavan Chebbi <pavan.chebbi@broadcom.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>,
 Stanislav Fomichev <sdf@fomichev.me>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>,
 Jian Shen <shenjian15@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
 Jijie Shao <shaojijie@huawei.com>, Sunil Goutham <sgoutham@marvell.com>,
 Geetha sowjanya <gakula@marvell.com>, Subbaraya Sundeep
 <sbhatta@marvell.com>, hariprasad <hkelam@marvell.com>,
 Bharat Bhushan <bbhushan2@marvell.com>, Saeed Mahameed <saeedm@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
 Leon Romanovsky <leon@kernel.org>, Alexander Duyck <alexanderduyck@fb.com>,
 kernel-team@meta.com, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Joe Damato <joe@dama.to>, David Wei <dw@davidwei.uk>,
 Willem de Bruijn <willemb@google.com>, Mina Almasry
 <almasrymina@google.com>, Breno Leitao <leitao@debian.org>,
 Dragos Tatulea <dtatulea@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-rdma@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, io-uring <io-uring@vger.kernel.org>
References: <cover.1760364551.git.asml.silence@gmail.com>
 <20251013105446.3efcb1b3@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251013105446.3efcb1b3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 18:54, Jakub Kicinski wrote:
> On Mon, 13 Oct 2025 15:54:02 +0100 Pavel Begunkov wrote:
>> Jakub Kicinski (20):
>>    docs: ethtool: document that rx_buf_len must control payload lengths
>>    net: ethtool: report max value for rx-buf-len
>>    net: use zero value to restore rx_buf_len to default
>>    net: clarify the meaning of netdev_config members
>>    net: add rx_buf_len to netdev config
>>    eth: bnxt: read the page size from the adapter struct
>>    eth: bnxt: set page pool page order based on rx_page_size
>>    eth: bnxt: support setting size of agg buffers via ethtool
>>    net: move netdev_config manipulation to dedicated helpers
>>    net: reduce indent of struct netdev_queue_mgmt_ops members
>>    net: allocate per-queue config structs and pass them thru the queue
>>      API
>>    net: pass extack to netdev_rx_queue_restart()
>>    net: add queue config validation callback
>>    eth: bnxt: always set the queue mgmt ops
>>    eth: bnxt: store the rx buf size per queue
>>    eth: bnxt: adjust the fill level of agg queues with larger buffers
>>    netdev: add support for setting rx-buf-len per queue
>>    net: wipe the setting of deactived queues
>>    eth: bnxt: use queue op config validate
>>    eth: bnxt: support per queue configuration of rx-buf-len
> 
> I'd like to rework these a little bit.
> On reflection I don't like the single size control.
> Please hold off.

I think that would be quite unproductive considering that this series
has been around for 3 months already with no forward progress, and the
API was posted 6 months ago. I have a better idea, I'll shrink it down
by removing all unnecessary parts, that makes it much much simpler and
should detangle the effort from ethtool bits like Stan once suggested.
I've also been bothered for some time by it growing to 24 patches, it'll
help with that as well. And it'll be a good base to put all the netlink
configuration bits on top if necessary.

> Also what's the resolution for the maintainers entry / cross posting?

I'm pretty much interested as well :) I've been CC'ing netdev as a
gesture of goodwill, that's despite you blocking an unrelated series
because of a rule you made up and retrospectively applied and belittling
my work after. It doesn't seem that you content with it either,
evidently from you blocking it again. I'm very curious what's that all
about? And since you're unwilling to deal with the series, maybe you'll
let other maintainers to handle it?

-- 
Pavel Begunkov


