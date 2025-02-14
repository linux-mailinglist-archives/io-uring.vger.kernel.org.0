Return-Path: <io-uring+bounces-6443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 958FAA36258
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 16:55:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C78CF3A2248
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 15:52:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97C68266F03;
	Fri, 14 Feb 2025 15:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="fahawTC/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2EB267382
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 15:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739548350; cv=none; b=lMdtcWkw0EOs7acPtS1NAfcyU+ZV08d2wDTGfsJCEJYW118GslxERwI/6/qNWVBeWuoAslZsQZzCfnBeO4IdtjHpKYug6C1Kr5UkXr+l3ybYWe7J1vlXEunONXFGQ47myHA3S6rP8U47E/C/vWaghuDZQbH028tCB96G43fXJgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739548350; c=relaxed/simple;
	bh=XV7RWNxqz2JtrAix1tJBxjzLRk2Aqkz0rONk4zwOU4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sKp04ey/8TUmiKE5R2lpxNpCB4NzzIxyx7ejCRAZGXOZ9E03ClbiSlvBEykMT2cH7Pwn/42fcLYx2rOsmFLFYP1j1NdGCFktH1XAFx5d0txUBh86qMON8h0ipz01SQLghTvx2qjz6lW8uRODsT3V6zejlOl4CyuKucnTQgBMntY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=fahawTC/; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2f9b9c0088fso3602050a91.0
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 07:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739548348; x=1740153148; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p2EbIYC0uVzNCy7iTVx+Dy809rdJPatzogkVI08UHyk=;
        b=fahawTC/R0jojmxMvKRyyjXnPM4oUtQvHGgpqjfepoX/TpoxqYCgKDADKRY2FJpk8l
         UkBOfWOExfpASTOOG8B86HdG7X0JsMsUYwzX8IqVFxf/uBUaGqZMzFYbJjJmrCei1IR6
         qh40CsrnJ7f640/FqBPYRU72YoDlDuClO9SgAHDxgPAP2BTvNmB0LheXABhEZyCTtHLb
         vZsb1Ho6eWgyGJtzw5C6bk8wCM+d/6m9VoYar8sT+mYyZ8MM1u27JovlvrHaptZrYdwi
         Cz83hQ7GAm3YfZLsWYJ0WXDL07tztWiQt5nRUEtkk4b4tI29q2eGAZciIGWA8Db9+I/t
         t6tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739548348; x=1740153148;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2EbIYC0uVzNCy7iTVx+Dy809rdJPatzogkVI08UHyk=;
        b=Zl/FSeJxOAegpV8emr3uRkDFEd+hVeFi4LXYDr9iyMye7cEUxdg34FGj/aBG1dAAqp
         HX3SBSiLx4AY0uNfcAYXdxyFximTPnnI1bwAKqH2p1hvCgs+GUXkotKu4rnRHnGSAoEL
         /y9jVZwWah6jIe+qkoMODSe8otaoySJuSVtYqnkXQcw7sUBM+oz1rRyRpGP5Iw/+WB7I
         oTuH7SG9YMW2CoyEydPqIPYxLJujadMkdlmcm3No3UnDDIZ6/N4u5l2OlthZdIMM6zdO
         34hg/BpBDRIvYbrCddekX9yLTO+E5p2fc0443edkyBaalI6BuAwFrSIQbhRJIQIBCl/N
         Ma1g==
X-Forwarded-Encrypted: i=1; AJvYcCWRRHxm0u9GasOmVBtQaOXEysaUhm8onVP7cEdpZXPmDMCwZ4W9rXPzMxAsGrFnUQxhrGL/5FZpWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuLTSwdNHGgbro6PIuIDMLtTq8mKLlLDZNe3wrKj819kAkOtwW
	vZ9aO2un39pSBJZ1hRrQ2EpLgnsCEwwysYypq9iTZGmX93E0Ox0muTPEvlvuqbo=
X-Gm-Gg: ASbGnctyTeMR0+iMWb7QI1kED+R9f3y7e1hm/bQEjqGqz7JwlQEaWWYLlyYNqXjQ2PX
	MlpazP1XkZuETTArTFToW39v6W7+Ed4hI7BqnHIP3uGFM2mhs92ZeManlJhOGkafHB08DJsWMoV
	ebOzo2929SYifTYmHd80diQYI3SSKXDmz9R9JWa1Ek9x8B/+Ma3lywjgpBPd3HNVismOVaZo2T/
	H0YP2sS/mvAZ+OJIlWKpVMPGqm4hpe7bFVhk0Q7SWons1YcPEH3LKy1YcyPsszxFgW9KXYN5jnj
	jI/0FIoQHThDUEStdTo6VjyubcUfjTA1bnocmTGEc8wioKiL0EhzJw==
X-Google-Smtp-Source: AGHT+IHI/9edEZ6v8VD549f9R04P+ORdW1u/DMbgiKYp1XqYeJmHgWxiAjXV5XwLrbJoSGkgLLoxQQ==
X-Received: by 2002:a17:90b:288c:b0:2fa:1d9f:c80 with SMTP id 98e67ed59e1d1-2fc0fa66b82mr11914353a91.17.1739548348126;
        Fri, 14 Feb 2025 07:52:28 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::6:902a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf999b602sm5360490a91.35.2025.02.14.07.52.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 07:52:27 -0800 (PST)
Message-ID: <2d3c2e58-914e-4151-a914-044ddc05ec9c@davidwei.uk>
Date: Fri, 14 Feb 2025 07:52:24 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
Content-Language: en-GB
To: lizetao <lizetao1@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20250212185859.3509616-1-dw@davidwei.uk>
 <20250212185859.3509616-12-dw@davidwei.uk>
 <81bc32eee1b1406883fb330efa341621@huawei.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <81bc32eee1b1406883fb330efa341621@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-02-13 19:27, lizetao wrote:
> Hi,
> 
>> -----Original Message-----
>> From: David Wei <dw@davidwei.uk>
>> Sent: Thursday, February 13, 2025 2:58 AM
>> To: io-uring@vger.kernel.org; netdev@vger.kernel.org
>> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov
>> <asml.silence@gmail.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
>> <edumazet@google.com>; Jesper Dangaard Brouer <hawk@kernel.org>; David
>> Ahern <dsahern@kernel.org>; Mina Almasry <almasrymina@google.com>;
>> Stanislav Fomichev <stfomichev@gmail.com>; Joe Damato
>> <jdamato@fastly.com>; Pedro Tammela <pctammela@mojatatu.com>
>> Subject: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
>>
>> Add a selftest for io_uring zero copy Rx. This test cannot run locally and
>> requires a remote host to be configured in net.config. The remote host must
>> have hardware support for zero copy Rx as listed in the documentation page.
>> The test will restore the NIC config back to before the test and is idempotent.
>>
>> liburing is required to compile the test and be installed on the remote host
>> running the test.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>  .../selftests/drivers/net/hw/.gitignore       |   2 +
>>  .../testing/selftests/drivers/net/hw/Makefile |   5 +
>>  .../selftests/drivers/net/hw/iou-zcrx.c       | 426 ++++++++++++++++++
>>  .../selftests/drivers/net/hw/iou-zcrx.py      |  64 +++
>>  4 files changed, 497 insertions(+)
>>  create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>>  create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py
>>
>> diff --git a/tools/testing/selftests/drivers/net/hw/.gitignore
>> b/tools/testing/selftests/drivers/net/hw/.gitignore
>> index e9fe6ede681a..6942bf575497 100644
>> --- a/tools/testing/selftests/drivers/net/hw/.gitignore
>> +++ b/tools/testing/selftests/drivers/net/hw/.gitignore
>> @@ -1 +1,3 @@
>> +# SPDX-License-Identifier: GPL-2.0-only iou-zcrx
>>  ncdevmem
>> diff --git a/tools/testing/selftests/drivers/net/hw/Makefile
>> b/tools/testing/selftests/drivers/net/hw/Makefile
>> index 21ba64ce1e34..7efc47c89463 100644
>> --- a/tools/testing/selftests/drivers/net/hw/Makefile
>> +++ b/tools/testing/selftests/drivers/net/hw/Makefile
>> @@ -1,5 +1,7 @@
>>  # SPDX-License-Identifier: GPL-2.0+ OR MIT
>>
>> +TEST_GEN_FILES = iou-zcrx
>> +
>>  TEST_PROGS = \
>>  	csum.py \
>>  	devlink_port_split.py \
>> @@ -10,6 +12,7 @@ TEST_PROGS = \
>>  	ethtool_rmon.sh \
>>  	hw_stats_l3.sh \
>>  	hw_stats_l3_gre.sh \
>> +	iou-zcrx.py \
>>  	loopback.sh \
>>  	nic_link_layer.py \
>>  	nic_performance.py \
>> @@ -38,3 +41,5 @@ include ../../../lib.mk  # YNL build  YNL_GENS := ethtool
>> netdev  include ../../../net/ynl.mk
>> +
>> +$(OUTPUT)/iou-zcrx: LDLIBS += -luring
>> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>> b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>> new file mode 100644
>> index 000000000000..010c261d2132
>> --- /dev/null
>> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>> @@ -0,0 +1,426 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +#include <assert.h>
>> +#include <errno.h>
>> +#include <error.h>
>> +#include <fcntl.h>
>> +#include <limits.h>
>> +#include <stdbool.h>
>> +#include <stdint.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <unistd.h>
>> +
>> +#include <arpa/inet.h>
>> +#include <linux/errqueue.h>
>> +#include <linux/if_packet.h>
>> +#include <linux/ipv6.h>
>> +#include <linux/socket.h>
>> +#include <linux/sockios.h>
>> +#include <net/ethernet.h>
>> +#include <net/if.h>
>> +#include <netinet/in.h>
>> +#include <netinet/ip.h>
>> +#include <netinet/ip6.h>
>> +#include <netinet/tcp.h>
>> +#include <netinet/udp.h>
>> +#include <sys/epoll.h>
>> +#include <sys/ioctl.h>
>> +#include <sys/mman.h>
>> +#include <sys/resource.h>
>> +#include <sys/socket.h>
>> +#include <sys/stat.h>
>> +#include <sys/time.h>
>> +#include <sys/types.h>
>> +#include <sys/un.h>
>> +#include <sys/wait.h>
>> +
> 
> When I compiled this testcase, I got some errors:
> 
>   iou-zcrx.c:145:9: error: variable ‘region_reg’ has initializer but incomplete type
>   iou-zcrx.c:148:12: error: ‘IORING_MEM_REGION_TYPE_USER’ undeclared (first use in this function)
>   ...
> 
> It seems that the linux/io_uring.h should be included here.
> 
> Also, after include this header file, some errors still exist. 
> 
>   iou-zcrx.c:(.text+0x5f0): undefined reference to `io_uring_register_ifq'
> 
> It is caused because io_uring_register_ifq symbol was not exported in liburing.

Yes there is a circular dependency here. This selftest depends on not
yet merged liburing changes, which can't be merged until the io_uring
kernel changes are merged. Which can't be done without a test...

We have two options: merge io_uring (this patchset), liburing, then
selftest. Or, merge this patchset followed by liburing and accept that
the test cannot be compiled until the latter is in.

> 
> Finally some warnings should also be fixed:
> 
>   iou-zcrx.c:288:17: warning: passing argument 2 of ‘bind’ from incompatible pointer type
>   iou-zcrx.c:326:18: warning: passing argument 2 of ‘connect’ from incompatible pointer type

I'll get this fixed.

> 
>> +#include <liburing.h>
> 
> ---
> Li Zetao

