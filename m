Return-Path: <io-uring+bounces-6451-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 740A4A3684C
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 23:32:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CAE5165251
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 22:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088691519B5;
	Fri, 14 Feb 2025 22:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="nKilgl/L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CC31D7985
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739572324; cv=none; b=Qs1Z1hQm+vIIiFGWedka6S0aeYptwNR8gSnTs+GkINs4IYJvmptL+cW8DeZ9jbrHYR4YAYcZ8/me57hOOZfuUAQRYXsMmhCYoAyHn5FjgTFvDGgojYRi25wK0jR4fZsMl3qJdwnzj6+W0QQiTzL20feDal5tnTy9urSFfOzy/M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739572324; c=relaxed/simple;
	bh=eSAW2Xsv92AnOELt/hEiVq43jepH+q7LIvPUi3Hkztg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q90xotqF79tAlcYlDqKTL1mhSi+iP09ghCtqLKQqcB4ZfioJqk0UH3XtEN3v7bgXjQMa4Fv50lNMtQycoMdTmGuNHcbf2AYPhAn1HnFhVMZwIrwEy/6wiDK3w6SgSoB3OxY7mxU05tgOBtlkdlMcSshb5VVC76DMZFWlc7xO+j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=nKilgl/L; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-220e83d65e5so34758045ad.1
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 14:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739572322; x=1740177122; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xVebVassuwOb0GOLZ0XW1Jz1GTZmB6rOBAl7S215u6Y=;
        b=nKilgl/LzcrycLLnIv/TMjSA6S1Ak1gYxf2qxYb++WlPEuMmRuWTdcVDjxGeKBW7eA
         5NFW65OD8u/cGelQORqYmM+FugpEX2omEYND3YLNfLDYo2MCHielzYr6Xb4Z5ZHA2i80
         QXVfK1pIqoAVjnqfUFy6PTicEgcPzqYX6Z25Lmu8n+HxwuLN+IZ2oYzMSltZPWjSffrg
         2buGxymKkOyITIaUFhHhNnTPeQWFUBv6D96x2xrvS19WUHKUgn/UR3oC5x7UfqUYiLmD
         S4Ua5dSawgYO5xwa8OW5rFOIPFHAHqplsj1oK3L/T/NI2H5wBS5keZXJHInSwgbzYh3a
         XbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739572322; x=1740177122;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xVebVassuwOb0GOLZ0XW1Jz1GTZmB6rOBAl7S215u6Y=;
        b=mo6QYrFHktXXV4qfbDUXiUADJ+t4ZpLAtvQ0Sq1JH+C/j4pc3qYfywLTqDvXMZgcT3
         uifxQE8sQygpFWBJr77QEcI4OHpBhSUkzSJ6BTAR/vSPZ2jzCnH7dnfAX/Hg8d38esHu
         8BcindY2BKXG0tUEuiN8PNKqanydN/bdpeAZRPmBSQIsuMz/hSy3XbFNglxEDSPAzEyp
         RLMtebbJZKhdlTzvqC+kS4LcszJJkEZsdMkpA5amQkOzg/25d/EBsqBu7JmZcMkAlPZR
         yavmEgD4JCF+tSVDk7p+oru+ipOEQuoR6MCRxS7MbP0OqIEMcz38djgLcm7H88xAjQVU
         urOw==
X-Forwarded-Encrypted: i=1; AJvYcCUVuQuYk4tt4CCiQiOFW3LbomBoTVzNTQH8oHuBDyCvulvb0CkQ3YcEhO2at3iNxjCSF7nOydV66g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfV/do4TxCGWBVZ6vp/PmKLhsg0ygbJ8g7BqmzJQo1cgIRxQH8
	hBU+hhKa5PpHgis4iU5c/pNK5cZOJ5EC2xemkC1saes7Mk3kC3nf0JxZGUkD0l8=
X-Gm-Gg: ASbGncvL9l+fEpTymmuNa6L5491NqAL6E+PGhWm7JbNzX13xM7N3hWkJKMbBaQcfkvL
	xNdd5xj7QUEaFPOm+TpuV/2zQSUwSjSo2FViz3ACbKaTywlZSqFUkOFGfPeE9CaGSAT8Nz7a2H2
	gdUDPWxyvg1I9LLtMFg/KXv9f/hP8nSIMRHbrP6e3uIkLdIkhrkjssEzufGmBG6Ux9uAdSxQIrc
	CDkVybrLd2busbGEqXEYCDc3SZuTMcVPalyH35dBV/5VZ5JCGKnbgtTICERA5TPLxZC/utxT+Zd
	LFbxOCfFn/CbsVFSgXuTCE9x4O5Wry1A5ZokqWhXcWI9VC5ScEjpYYEUd0E=
X-Google-Smtp-Source: AGHT+IGjbLL76HF8/7Vesxkk8MYzXoTk321xSXr6GDRjOe2YzfHuSQRPdjS1ENoOHeSgJrIiHOTWrQ==
X-Received: by 2002:a05:6a21:110:b0:1ee:7b6c:e2f4 with SMTP id adf61e73a8af0-1ee8cba4e1bmr1863270637.26.1739572322485;
        Fri, 14 Feb 2025 14:32:02 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::6:902a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7324277f28asm3605617b3a.163.2025.02.14.14.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2025 14:32:02 -0800 (PST)
Message-ID: <057cb8a9-97ca-47c6-bad0-19f3780a08cd@davidwei.uk>
Date: Fri, 14 Feb 2025 14:31:59 -0800
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

On 2025-02-13 18:27, lizetao wrote:
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
> 
> Finally some warnings should also be fixed:
> 
>   iou-zcrx.c:288:17: warning: passing argument 2 of ‘bind’ from incompatible pointer type
>   iou-zcrx.c:326:18: warning: passing argument 2 of ‘connect’ from incompatible pointer type

Hmm I don't get these warnings with neither GCC nor clang. What is your
setup?

$ gcc --version
gcc (GCC) 11.5.0 20240719 (Red Hat 11.5.0-2)

$ clang --version
clang version 19.1.5 (CentOS 19.1.5-2.el9)

> 
>> +#include <liburing.h>
> 
> ---
> Li Zetao

