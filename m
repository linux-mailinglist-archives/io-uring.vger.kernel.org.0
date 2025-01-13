Return-Path: <io-uring+bounces-5847-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6E4A0C3C6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 22:32:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3C837A4441
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 21:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1BD1C1AAA;
	Mon, 13 Jan 2025 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RdObDYT3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E7E1D2F42;
	Mon, 13 Jan 2025 21:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736803917; cv=none; b=ghARhsTBA6HyRlauhi+5/0ZmlYpB4IvvNLMrK63i+kdv0L+HfsdcX4caWm+N8De0hBZHnbPrRYIXa2icig823xersoaJH9ROSXhM6jbstWDZAzK9BxCcFJU6gU/yAn4FPkaZDs7KjP3aiokJKR4sgbDPIXrxHVysj0daiORWOkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736803917; c=relaxed/simple;
	bh=n7GshRAXf76nkqa/s8gptzaSaw6LPoNpYHT5c1jIhxM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A6PJQ3Wzt8xc62o0ahBMyfWk0ONckLY9vC8WZOXXNgAUEiehtkMqS9dtAAtWqKaObHb0Wv5jny+70Ojn8KvZhJnBwPidfYmeT6LYSlFM96ekGS6NfXQG8ob1PZoZHvsMQedOLC/A7QykAli84NxiM1oV5Hlxem6vBK5d+y5N/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RdObDYT3; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aafc9d75f8bso934561466b.2;
        Mon, 13 Jan 2025 13:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736803914; x=1737408714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xcqebGW56Xk0xpEewyw7mLae81W7+Apdj3yKeIf97Sk=;
        b=RdObDYT36trg2KyO6dl8+mcHM7Vqflnhwir9N1EU99gFz65TVKOKDAoBc7gYX2jjPK
         YD8CcyEUS7mLIWFLxG8WfLQIkeWpCAMfR04deKNsjgF9GLFEhfU5+A6F5COh8/+cwMyr
         6KCm5BEFN6dqYfLsk4SJ/xFjicNOCQ5Je8DX8yrvQHLyPT/wMp76W344CgYkLOzibLBs
         tVBIC4S1oP59M5Zqp8DvGlLZsTHqyk/YUERdhhVPAFmjAppsUNoN4ceD4LgEY8ZM8XWn
         xwbUtsMG307G4JWfnJG68BOsIEnY8DRByYzOB+FN6d9xE8UJkabHGR3wMOm1mauIl344
         RIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736803914; x=1737408714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcqebGW56Xk0xpEewyw7mLae81W7+Apdj3yKeIf97Sk=;
        b=H5AuzS5XRQNJdb46rkhLdfjAFElgpxlcv+9xZf2lqvnCA9c+AEv1pz6u9rV31WriT9
         /wQCAS8X9qV6NH0I+gNJx5wW22yAjOysUPgq0THRIGLXVakogz3oYcgFcXIfC7QsmYU/
         s1aNIqYNX/DXnqPW6a90RRS8sI9h489s3/hUjYvXZ2XJnsWvKpIGo8EJDNYC9jfeIIF+
         1rvuepWVq/JVJ2JmL5mJ9ehDjW6uMSVcaSAB9SlYjkRcg3Sjz9mzo7LupqD8edN39IWl
         vKUmGk+7vzQlhM7YdOdkJ26p+B4MwOsC86WDqdAs+3J4jjl1jAK1wl2+itQsL7dCgH8v
         3qJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmW7uezlVDg9oGteYKRyfACjTj9NQ+sOC12bjqssxu0ikzrCD5PWcJsh+kM1vwFlYXOt0iyZQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YykSp5I7/+7y+5QOTOoARRd2LUUcNmsHyPrla8o+fZaYPApfN+y
	w/V5LQkPHhhH9F3xj7mDdHuE1qaB/29YY0BkYpQHwJSrt8Yk+ClH
X-Gm-Gg: ASbGncu/70tIeHztHILuJzONeyd7K9g3CANJ1PVduH599UZw4ch4GUdHlKF6i3bWAs3
	EAOIWnUmuBJzBhQMeWvaUOanRy0qP+IWjvptWGpv4iZjM5rO2C9dcrwjSD7vlt+5cLctL/84Swz
	JHeUXhBwAIjiGvatdtG5LVFHVxSoEGU4d5C6lTztOn7Ml5Cj6DII/mCY/BTQXqHqkNwULQSswky
	yWMGZVYhkqoUuOxRzPRUEP95Vx809o/th81auaAOK36SOm882T2jAyi/K3Us1N9TnI=
X-Google-Smtp-Source: AGHT+IHBCpb2yM4oUtPUKA34nX4lV7WSfwEW/JsepI23ZmImJ/nXV9Qg8k6dTi7l7J0yfIQVN46sWg==
X-Received: by 2002:a17:907:c03:b0:aa6:84c3:70e2 with SMTP id a640c23a62f3a-ab2ab6fe0d9mr2025322466b.20.1736803913928;
        Mon, 13 Jan 2025 13:31:53 -0800 (PST)
Received: from [192.168.8.100] ([148.252.140.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90e3f54sm548018166b.81.2025.01.13.13.31.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2025 13:31:53 -0800 (PST)
Message-ID: <08bc45ec-93d4-4220-81d5-7377b3daa5cc@gmail.com>
Date: Mon, 13 Jan 2025 21:32:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 22/22] io_uring/zcrx: add selftest
To: David Wei <dw@davidwei.uk>, Stanislav Fomichev <stfomichev@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-23-dw@davidwei.uk> <Z4AIhGgAZPe8Ie-g@mini-arch>
 <a58b7f2a-2441-4e71-9f56-76f78d0180e4@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a58b7f2a-2441-4e71-9f56-76f78d0180e4@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/25 17:50, David Wei wrote:
> On 2025-01-09 09:33, Stanislav Fomichev wrote:
>> On 01/08, David Wei wrote:
>>> Add a selftest for io_uring zero copy Rx. This test cannot run locally
>>> and requires a remote host to be configured in net.config. The remote
>>> host must have hardware support for zero copy Rx as listed in the
>>> documentation page. The test will restore the NIC config back to before
>>> the test and is idempotent.
>>>
[...]
>>> +
>>> +		if (addr &&
>>> +		    inet_pton(AF_INET6, addr, &(addr6->sin6_addr)) != 1)
>>> +			error(1, 0, "ipv6 parse error: %s", addr);
>>> +		break;
>>
>> nit: let's drop explicit af_inet support and use dual-stack af_inet6 sockets
>> explicitly? Take a look at parse_address in
>> tools/testing/selftests/drivers/net/hw/ncdevmem.c on how to
>> transparently fallback to v4 (maybe even move that parsing function into
>> some new networking_helpers.c lib similar to bpf subtree?).
>>
>> (context: pure v4 environments are unlikely to exist at this point;
>> anything that supports v6 can use v4-mapped-v6 addresses)
>>
>>> +	default:
>>> +		error(1, 0, "illegal domain");
>>> +	}
>>> +
>>> +	if (cfg_payload_len > max_payload_len)
>>> +		error(1, 0, "-l: payload exceeds max (%d)", max_payload_len);
>>> +}
>>> +
...
>> [..]
>>
>>> +def _get_rx_ring_entries(cfg):
>>> +    eth_cmd = "ethtool -g {} | awk '/RX:/ {{count++}} count == 2 {{print $2; exit}}'"
>>> +    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
>>> +    return int(res.stdout)
>>> +
>>> +
>>> +def _get_combined_channels(cfg):
>>> +    eth_cmd = "ethtool -l {} | awk '/Combined:/ {{count++}} count == 2 {{print $2; exit}}'"
>>> +    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
>>> +    return int(res.stdout)
>>> +
>>> +
>>> +def _set_flow_rule(cfg, chan):
>>> +    eth_cmd = "ethtool -N {} flow-type tcp6 dst-port 9999 action {} | awk '{{print $NF}}'"
>>> +    res = cmd(eth_cmd.format(cfg.ifname, chan), host=cfg.remote)
>>> +    return int(res.stdout)
>>
>> Most of these (except installing flow steering rule) can be done over
>> ethtool ynl family. Should we try to move them over to YNL calls instead
>> of shelling out to ethtool binary? There are some examples in rss_ctx.py
>> on how to work with ethtool spec.
>>
>> Same for setting/resetting number of queues below.
> 
> I wanted to use YNL, but these commands are run on the remote host and
> it's currently challenging to use YNL there.
> 
>>
>> For the rest, there is also a ethtool() wrapper so you don't have to
>> do cmd("ethtool ...") and can do ethtool("...").
> 
> SG, I will update to use ethtool() helper.

If there will be no more issues / concerns, I'd assume we can merge
this series and follow up on top, as it rather sounds like an
improvement but not a real problem. Stan, does it work for you?

-- 
Pavel Begunkov


