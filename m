Return-Path: <io-uring+bounces-6449-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69915A367E6
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 22:57:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BFAFB7A4458
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 21:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AC5B1C84B7;
	Fri, 14 Feb 2025 21:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="E59WEfiP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6CE192D97
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 21:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739570268; cv=none; b=srd2AzV34KZr7BoCDHjROhBjIqsmZFSrWCmRY6CLWSRxLWtIKFx/L66b7faCogXVT4T/CGyJCmW+CmszL5L2Nvo05JFGQ95jGifYNeX4fgP/VDvrmu594Z1l1NSaLNvMhSn5NjHlvney/7E0Q54Ovc97txKm6Vh2aVMaEeoQcOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739570268; c=relaxed/simple;
	bh=r6kVMKGirSEJe7TF6Xo2qNQEsYKbW9F5AuLesd45Smk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=rL2jb8UIgvPLb+BQNMVvGjFytf+gyuLD7Ryq2EwkdesVhTifj1nCYyOO6Une76+WHE4HAgMn6tSVBmG7P9vy1CzLFOlwuNAagXCif5x7dmu+J7+N/Z/f3tGXo8fO3QPS08byyALcu3vorwfeWkKgF1V+/a61JDopBPLpnUlMlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=E59WEfiP; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-220c8f38febso47826615ad.2
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 13:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739570266; x=1740175066; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XIIummCoayGbwcVGsxxImxQ1yPyHFCOxvBRensQx0Fo=;
        b=E59WEfiPtMN4IHGm44pwRgQ9PjvYgJGXrhVm8cFrEFfHIl/uExCy9le3LeTexztt3H
         AxYBEcj5HiNKH4YYSFWg6+X7rVGEGSx2guXf9V4S/o4+WK45XCt79h6Ddx5bY5x+zAuN
         CbOzp07BhjcEfyCUCg8b2/v9eiLA4Vp0bpxStslbNaVeIufOuqQFWPLpx2lsega/bO46
         qSJdqBjKTQ4vtLsY9oCtQteLe/ug1T+/OooyWm2eSx+rIE7gLjr9ji+Mifi2u2Rlrytv
         cjEbZeRJY3YJdNNCUL3w6EKdw8FGHwSyZtZpe+SFBkh08egAj1fd/bRRWVNRA+t1vdz4
         rBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739570266; x=1740175066;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XIIummCoayGbwcVGsxxImxQ1yPyHFCOxvBRensQx0Fo=;
        b=ENztwP5123sHVj+kjbqS+xV7PrktxJUMMv2Z5qzbvOz3xzngXk791i0mQZEtoHiBRB
         ySPiZF2C/4ZmELB1K63fBhgI6U8lip0w9zAyEM5mtRglCqkf6c3L/CDy6QFhARtEw65R
         TLdcCvMPNhIFJPmfvttRDMQ9NaidUwriVIsBdTt1rjEJMSWHpmz78SFEkqAvf2+yCm/i
         iAVlGpShAbwSOWGpwJVPOpuTJM63VvLis2GMZe9LKSNe6iIkUb2T2V68QIA+juie18ZE
         eZ4KB//TGr9pXNwtAihvvOG3HvJPqwCp+cvZOz12ubT+7yN7QbUAxldp2zSMBTiBni1L
         n9wQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyO0njlEzxuAJ0tIdztZfmt4FOM1tp/cNnwHp/FeOkWSjH3WXynd9DwO2sLPMU+gb8LB5rgux56g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzZC4weTFXUPZ8d0jDWyWamxnf58U4H94Zjq64Nxfoie0Lh0lTa
	6oC1i6g9Vxy9589Bfc5BOwk5+6PAn+BTTGasR6RFPAyESb7StJRW4VJGkheQSkw=
X-Gm-Gg: ASbGncujioVvqx45fT8o6f8XlXSHvTBvNjBE8JsrzEWE4VuVIcmEpxRcwk4kSXk8YCW
	8vZeEGORiUcc3+YyQRAQP7bqzh+fEbiEzDKsKIlva2oubvnyVusDwjmFBh8wX/6t94eVZ+WARdz
	IlgvvbDn1IkBB223xsF8qiZj4mmeXHC2rkZwwp5uBbKpEm5IYRE04ukTr1+ftjCq0JrSUzYBpAo
	Yv89Z+Ygwzi2q6WBXDwuOotW90XTh2Dcd74iYef+q70Fm3eNsz11lxS16lcaTaW1kS7uwVg+9o5
	kSiCvACS4MzOuPRgxrQ6ElpjtP6+9Hb9wUu+cI4FmHzKZxUtg6cWkvUl6PY=
X-Google-Smtp-Source: AGHT+IF7P6yLxhqruK4lwgO8TlgisPmqpT9y6hxiSOFySvwbjmQUGyxSJY2yTas2hUu8NTeRr4JGmA==
X-Received: by 2002:a17:902:f54e:b0:21f:33:ad2 with SMTP id d9443c01a7336-221040d7530mr13056985ad.52.1739570265645;
        Fri, 14 Feb 2025 13:57:45 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::6:902a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d55960ecsm33291845ad.253.2025.02.14.13.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 13:57:44 -0800 (PST)
Message-ID: <f74bcd90-bc74-4d1f-abc7-87f5b7c71c98@davidwei.uk>
Date: Fri, 14 Feb 2025 13:57:42 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
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
 <2d3c2e58-914e-4151-a914-044ddc05ec9c@davidwei.uk>
In-Reply-To: <2d3c2e58-914e-4151-a914-044ddc05ec9c@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-02-14 07:52, David Wei wrote:
> On 2025-02-13 19:27, lizetao wrote:
>> Hi,
>>
>>> -----Original Message-----
>>> From: David Wei <dw@davidwei.uk>
>>> Sent: Thursday, February 13, 2025 2:58 AM
>>> To: io-uring@vger.kernel.org; netdev@vger.kernel.org
>>> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov
>>> <asml.silence@gmail.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
>>> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
>>> <edumazet@google.com>; Jesper Dangaard Brouer <hawk@kernel.org>; David
>>> Ahern <dsahern@kernel.org>; Mina Almasry <almasrymina@google.com>;
>>> Stanislav Fomichev <stfomichev@gmail.com>; Joe Damato
>>> <jdamato@fastly.com>; Pedro Tammela <pctammela@mojatatu.com>
>>> Subject: [PATCH net-next v13 11/11] io_uring/zcrx: add selftest
>>>
>>> Add a selftest for io_uring zero copy Rx. This test cannot run locally and
>>> requires a remote host to be configured in net.config. The remote host must
>>> have hardware support for zero copy Rx as listed in the documentation page.
>>> The test will restore the NIC config back to before the test and is idempotent.
>>>
>>> liburing is required to compile the test and be installed on the remote host
>>> running the test.
>>>
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>>  .../selftests/drivers/net/hw/.gitignore       |   2 +
>>>  .../testing/selftests/drivers/net/hw/Makefile |   5 +
>>>  .../selftests/drivers/net/hw/iou-zcrx.c       | 426 ++++++++++++++++++
>>>  .../selftests/drivers/net/hw/iou-zcrx.py      |  64 +++
>>>  4 files changed, 497 insertions(+)
>>>  create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>>>  create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py
>>>
>>> diff --git a/tools/testing/selftests/drivers/net/hw/.gitignore
>>> b/tools/testing/selftests/drivers/net/hw/.gitignore
>>> index e9fe6ede681a..6942bf575497 100644
>>> --- a/tools/testing/selftests/drivers/net/hw/.gitignore
>>> +++ b/tools/testing/selftests/drivers/net/hw/.gitignore
>>> @@ -1 +1,3 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only iou-zcrx
>>>  ncdevmem
>>> diff --git a/tools/testing/selftests/drivers/net/hw/Makefile
>>> b/tools/testing/selftests/drivers/net/hw/Makefile
>>> index 21ba64ce1e34..7efc47c89463 100644
>>> --- a/tools/testing/selftests/drivers/net/hw/Makefile
>>> +++ b/tools/testing/selftests/drivers/net/hw/Makefile
>>> @@ -1,5 +1,7 @@
>>>  # SPDX-License-Identifier: GPL-2.0+ OR MIT
>>>
>>> +TEST_GEN_FILES = iou-zcrx
>>> +
>>>  TEST_PROGS = \
>>>  	csum.py \
>>>  	devlink_port_split.py \
>>> @@ -10,6 +12,7 @@ TEST_PROGS = \
>>>  	ethtool_rmon.sh \
>>>  	hw_stats_l3.sh \
>>>  	hw_stats_l3_gre.sh \
>>> +	iou-zcrx.py \
>>>  	loopback.sh \
>>>  	nic_link_layer.py \
>>>  	nic_performance.py \
>>> @@ -38,3 +41,5 @@ include ../../../lib.mk  # YNL build  YNL_GENS := ethtool
>>> netdev  include ../../../net/ynl.mk
>>> +
>>> +$(OUTPUT)/iou-zcrx: LDLIBS += -luring
>>> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>>> b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>>> new file mode 100644
>>> index 000000000000..010c261d2132
>>> --- /dev/null
>>> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>>> @@ -0,0 +1,426 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +#include <assert.h>
>>> +#include <errno.h>
>>> +#include <error.h>
>>> +#include <fcntl.h>
>>> +#include <limits.h>
>>> +#include <stdbool.h>
>>> +#include <stdint.h>
>>> +#include <stdio.h>
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <unistd.h>
>>> +
>>> +#include <arpa/inet.h>
>>> +#include <linux/errqueue.h>
>>> +#include <linux/if_packet.h>
>>> +#include <linux/ipv6.h>
>>> +#include <linux/socket.h>
>>> +#include <linux/sockios.h>
>>> +#include <net/ethernet.h>
>>> +#include <net/if.h>
>>> +#include <netinet/in.h>
>>> +#include <netinet/ip.h>
>>> +#include <netinet/ip6.h>
>>> +#include <netinet/tcp.h>
>>> +#include <netinet/udp.h>
>>> +#include <sys/epoll.h>
>>> +#include <sys/ioctl.h>
>>> +#include <sys/mman.h>
>>> +#include <sys/resource.h>
>>> +#include <sys/socket.h>
>>> +#include <sys/stat.h>
>>> +#include <sys/time.h>
>>> +#include <sys/types.h>
>>> +#include <sys/un.h>
>>> +#include <sys/wait.h>
>>> +
>>
>> When I compiled this testcase, I got some errors:
>>
>>   iou-zcrx.c:145:9: error: variable ‘region_reg’ has initializer but incomplete type
>>   iou-zcrx.c:148:12: error: ‘IORING_MEM_REGION_TYPE_USER’ undeclared (first use in this function)
>>   ...
>>
>> It seems that the linux/io_uring.h should be included here.
>>
>> Also, after include this header file, some errors still exist. 
>>
>>   iou-zcrx.c:(.text+0x5f0): undefined reference to `io_uring_register_ifq'
>>
>> It is caused because io_uring_register_ifq symbol was not exported in liburing.
> 
> Yes there is a circular dependency here. This selftest depends on not
> yet merged liburing changes, which can't be merged until the io_uring
> kernel changes are merged. Which can't be done without a test...
> 
> We have two options: merge io_uring (this patchset), liburing, then
> selftest. Or, merge this patchset followed by liburing and accept that
> the test cannot be compiled until the latter is in.

You can find a working liburing branch here:

https://github.com/spikeh/liburing/commits/zcrx/next/

I will continue with this patchset and land the liburing changes
afterwards.

> 
>>
>> Finally some warnings should also be fixed:
>>
>>   iou-zcrx.c:288:17: warning: passing argument 2 of ‘bind’ from incompatible pointer type
>>   iou-zcrx.c:326:18: warning: passing argument 2 of ‘connect’ from incompatible pointer type
> 
> I'll get this fixed.
> 
>>
>>> +#include <liburing.h>
>>
>> ---
>> Li Zetao

