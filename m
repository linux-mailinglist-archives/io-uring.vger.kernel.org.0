Return-Path: <io-uring+bounces-5790-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A07BA07F47
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 18:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26B511886010
	for <lists+io-uring@lfdr.de>; Thu,  9 Jan 2025 17:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC0818C92F;
	Thu,  9 Jan 2025 17:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="EF4wYNSe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5C018A95A
	for <io-uring@vger.kernel.org>; Thu,  9 Jan 2025 17:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736445059; cv=none; b=FdwJvAeOAKhVugqDHhS3Yb27qf4lriCosXQMvjY88pit0zhsEL/nz3uyTHlmmD9JsEM2KwP6PK2HTxbSbBjPF5klEXj3vOpIXdkHqO2mKYh0Nu4yvA0iQBl68FMo/lIOCoWXWZgrC2TzhzY8j2co+LTt5o5k5NrZR2FwGWJUGl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736445059; c=relaxed/simple;
	bh=zC6RAOPj/g0pQKJpieplgq8ndMNQxG8gQo9Ddd1VG0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s1u4FamhKfCl0ZUlXgcLCtFkVrfciftKSKhCrbBqDFLU3O7fiCFQxPYFIybVXyjp0+Jr2RSPRdZ+cSt+IlJFKAw7WeqI3rBjAbTFwjYd6PNS2pM2CBlMXNVZUAdXB7edZ0rBSYDjfItMFS289z5ejQVTKBG0GYkOTwKLBYv101g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=EF4wYNSe; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-216426b0865so19934575ad.0
        for <io-uring@vger.kernel.org>; Thu, 09 Jan 2025 09:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736445056; x=1737049856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SUFJlzUad/wpk4JI/4I23cyd6Rjm95bTNPSfrPAvVvY=;
        b=EF4wYNSeKLttWvOdtyKWb4BBxVKhCOvFCMrfXpjaXs1XLa8LfG64G4CoNREzCQe68r
         gK3NdEHRHYNZXQTdHYtRrV0IZjgkDt2wKdeoB7yEQ0wipHHaBv89isPh9w3R8ru4WIs2
         EJwq40dvZDliDNTWeDc7EnaQF4Ue69SGTsoAnaW1x5jXc4OVm+uOB4k4cMEt5gJQ6zmY
         guiPvaQgv7bvc2JLhbsFYhl1QtUGIzGrZQeybQhueSZANWuc3A8SF6gCiqy9OLy0iWn/
         feXp1BozOlfbfAnZl0nzCPgFjfB4+KzSP2yNpGJxt68pC+u17SMsAY6D8aNwSdAXQxzY
         QZoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736445056; x=1737049856;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUFJlzUad/wpk4JI/4I23cyd6Rjm95bTNPSfrPAvVvY=;
        b=WCYdvhy/kDkaWUchdObJf97Th3zoIKfRqgBWP9GoaQ8AcUPlV2C1Zf9FGfwFPx/+GC
         9Vu6ByTzqGIg8F6RKnYFddjgqwryfFwfhJH15SyZRu0pBmhr7/+5iWpb/hcmXDg4+gVD
         9B18INi7OiARcRnVWX285djNMU5jzFonJWsA+qE1WRpHzDG9ueh3p+PRxLe0s83Up5++
         dTxSMSK/eDnlWg1ndBTc4v1ehNxt0zzOLm/Ky1FnFOpwTPeCc6mBkmRQeX/EdjoytA9f
         h8yTxSk0b+sgZ5tChsCMHd25JwBdzNNxpx6ETzQdah6lTn/cuntzuhlgS3/TEmjPpTD8
         GOvg==
X-Gm-Message-State: AOJu0Yyd4MsadrkxKWB4Su1MNDkdi47XAzofqJ1eqajRot1Vd5R0Rzs8
	RwEq69NTW3kew7W/T7/3rP1/AHhuEby9WZGwy8N20IFEwgD49kLAkw++PmpOw+4=
X-Gm-Gg: ASbGncuZWVDFXe7ZosWhSKjeVcDG2THbLMmSxEwowBWD8v2ooN5LKNid9iOX4CF1E22
	8/I/VFFSS0OikowfD6xStxsqV4C7MF6Ntr3KHdZTSCMGAH7pr4NFIGxS0rGMy7aenO5p8cAK41R
	icVkKFcsG0RRjGDTAu5h4XNCkjoWXdoAmfYEn+uKiYqWCsDwYdURQI6IpbsPTIj4wAGV4+Wt1Fb
	mwpdWCqRdF8GLGW6E0JB7nG9PFj0ycc9a3C46Q05volp9lPAC8jfCCCbniUUll+7+LW50tGSRT3
	mvFvdQx8WyMftmaTTWEC3bM=
X-Google-Smtp-Source: AGHT+IEoIECWZJks3Sgwd2jYyuGBraNsi7KGql56ihu+th2Zjd90+agG7nQo6Skr9LZ8f5LGxr+WGw==
X-Received: by 2002:a05:6a20:72ab:b0:1e1:f281:8cfd with SMTP id adf61e73a8af0-1e88cfa701emr11434693637.15.1736445054697;
        Thu, 09 Jan 2025 09:50:54 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:a:43b:6f2e:11b7:73ec? ([2620:10d:c090:500::7:bdfc])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72d40658cd0sm61046b3a.113.2025.01.09.09.50.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 09:50:54 -0800 (PST)
Message-ID: <a58b7f2a-2441-4e71-9f56-76f78d0180e4@davidwei.uk>
Date: Thu, 9 Jan 2025 09:50:51 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 22/22] io_uring/zcrx: add selftest
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-23-dw@davidwei.uk> <Z4AIhGgAZPe8Ie-g@mini-arch>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <Z4AIhGgAZPe8Ie-g@mini-arch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-01-09 09:33, Stanislav Fomichev wrote:
> On 01/08, David Wei wrote:
>> Add a selftest for io_uring zero copy Rx. This test cannot run locally
>> and requires a remote host to be configured in net.config. The remote
>> host must have hardware support for zero copy Rx as listed in the
>> documentation page. The test will restore the NIC config back to before
>> the test and is idempotent.
>>
>> liburing is required to compile the test and be installed on the remote
>> host running the test.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>  .../selftests/drivers/net/hw/.gitignore       |   2 +
>>  .../testing/selftests/drivers/net/hw/Makefile |   6 +
>>  .../selftests/drivers/net/hw/iou-zcrx.c       | 432 ++++++++++++++++++
>>  .../selftests/drivers/net/hw/iou-zcrx.py      |  64 +++
>>  4 files changed, 504 insertions(+)
>>  create mode 100644 tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>>  create mode 100755 tools/testing/selftests/drivers/net/hw/iou-zcrx.py
>>
>> diff --git a/tools/testing/selftests/drivers/net/hw/.gitignore b/tools/testing/selftests/drivers/net/hw/.gitignore
>> index e9fe6ede681a..6942bf575497 100644
>> --- a/tools/testing/selftests/drivers/net/hw/.gitignore
>> +++ b/tools/testing/selftests/drivers/net/hw/.gitignore
>> @@ -1 +1,3 @@
>> +# SPDX-License-Identifier: GPL-2.0-only
>> +iou-zcrx
>>  ncdevmem
>> diff --git a/tools/testing/selftests/drivers/net/hw/Makefile b/tools/testing/selftests/drivers/net/hw/Makefile
>> index 21ba64ce1e34..5431af8e8210 100644
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
>> @@ -38,3 +41,6 @@ include ../../../lib.mk
>>  # YNL build
>>  YNL_GENS := ethtool netdev
>>  include ../../../net/ynl.mk
>> +
>> +$(OUTPUT)/iou-zcrx: CFLAGS += -I/usr/include/
>> +$(OUTPUT)/iou-zcrx: LDLIBS += -luring
>> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>> new file mode 100644
>> index 000000000000..0809db134bba
>> --- /dev/null
>> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
>> @@ -0,0 +1,432 @@
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
>> +#include <liburing.h>
>> +
>> +#define PAGE_SIZE (4096)
>> +#define AREA_SIZE (8192 * PAGE_SIZE)
>> +#define SEND_SIZE (512 * 4096)
>> +#define min(a, b) \
>> +	({ \
>> +		typeof(a) _a = (a); \
>> +		typeof(b) _b = (b); \
>> +		_a < _b ? _a : _b; \
>> +	})
>> +#define min_t(t, a, b) \
>> +	({ \
>> +		t _ta = (a); \
>> +		t _tb = (b); \
>> +		min(_ta, _tb); \
>> +	})
>> +
>> +#define ALIGN_UP(v, align) (((v) + (align) - 1) & ~((align) - 1))
>> +
>> +static int cfg_family = PF_UNSPEC;
>> +static int cfg_server;
>> +static int cfg_client;
>> +static int cfg_port = 8000;
>> +static int cfg_payload_len;
>> +static const char *cfg_ifname;
>> +static int cfg_queue_id = -1;
>> +
>> +static socklen_t cfg_alen;
>> +static struct sockaddr_storage cfg_addr;
>> +
>> +static char payload[SEND_SIZE] __attribute__((aligned(PAGE_SIZE)));
>> +static void *area_ptr;
>> +static void *ring_ptr;
>> +static size_t ring_size;
>> +static struct io_uring_zcrx_rq rq_ring;
>> +static unsigned long area_token;
>> +static int connfd;
>> +static bool stop;
>> +static size_t received;
>> +
>> +static unsigned long gettimeofday_ms(void)
>> +{
>> +	struct timeval tv;
>> +
>> +	gettimeofday(&tv, NULL);
>> +	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
>> +}
>> +
>> +static inline size_t get_refill_ring_size(unsigned int rq_entries)
>> +{
>> +	size_t size;
>> +
>> +	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
>> +	/* add space for the header (head/tail/etc.) */
>> +	ring_size += PAGE_SIZE;
>> +	return ALIGN_UP(ring_size, 4096);
>> +}
>> +
>> +static void setup_zcrx(struct io_uring *ring)
>> +{
>> +	unsigned int ifindex;
>> +	unsigned int rq_entries = 4096;
>> +	int ret;
>> +
>> +	ifindex = if_nametoindex(cfg_ifname);
>> +	if (!ifindex)
>> +		error(1, 0, "bad interface name: %s", cfg_ifname);
>> +
>> +	area_ptr = mmap(NULL,
>> +			AREA_SIZE,
>> +			PROT_READ | PROT_WRITE,
>> +			MAP_ANONYMOUS | MAP_PRIVATE,
>> +			0,
>> +			0);
>> +	if (area_ptr == MAP_FAILED)
>> +		error(1, 0, "mmap(): zero copy area");
>> +
>> +	ring_size = get_refill_ring_size(rq_entries);
>> +	ring_ptr = mmap(NULL,
>> +			ring_size,
>> +			PROT_READ | PROT_WRITE,
>> +			MAP_ANONYMOUS | MAP_PRIVATE,
>> +			0,
>> +			0);
>> +
>> +	struct io_uring_region_desc region_reg = {
>> +		.size = ring_size,
>> +		.user_addr = (__u64)(unsigned long)ring_ptr,
>> +		.flags = IORING_MEM_REGION_TYPE_USER,
>> +	};
>> +
>> +	struct io_uring_zcrx_area_reg area_reg = {
>> +		.addr = (__u64)(unsigned long)area_ptr,
>> +		.len = AREA_SIZE,
>> +		.flags = 0,
>> +	};
>> +
>> +	struct io_uring_zcrx_ifq_reg reg = {
>> +		.if_idx = ifindex,
>> +		.if_rxq = cfg_queue_id,
>> +		.rq_entries = rq_entries,
>> +		.area_ptr = (__u64)(unsigned long)&area_reg,
>> +		.region_ptr = (__u64)(unsigned long)&region_reg,
>> +	};
>> +
>> +	ret = io_uring_register_ifq(ring, &reg);
>> +	if (ret)
>> +		error(1, 0, "io_uring_register_ifq(): %d", ret);
>> +
>> +	rq_ring.khead = (unsigned int *)((char *)ring_ptr + reg.offsets.head);
>> +	rq_ring.ktail = (unsigned int *)((char *)ring_ptr + reg.offsets.tail);
>> +	rq_ring.rqes = (struct io_uring_zcrx_rqe *)((char *)ring_ptr + reg.offsets.rqes);
>> +	rq_ring.rq_tail = 0;
>> +	rq_ring.ring_entries = reg.rq_entries;
>> +
>> +	area_token = area_reg.rq_area_token;
>> +}
>> +
>> +static void add_accept(struct io_uring *ring, int sockfd)
>> +{
>> +	struct io_uring_sqe *sqe;
>> +
>> +	sqe = io_uring_get_sqe(ring);
>> +
>> +	io_uring_prep_accept(sqe, sockfd, NULL, NULL, 0);
>> +	sqe->user_data = 1;
>> +}
>> +
>> +static void add_recvzc(struct io_uring *ring, int sockfd)
>> +{
>> +	struct io_uring_sqe *sqe;
>> +
>> +	sqe = io_uring_get_sqe(ring);
>> +
>> +	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, sockfd, NULL, 0, 0);
>> +	sqe->ioprio |= IORING_RECV_MULTISHOT;
>> +	sqe->user_data = 2;
>> +}
>> +
>> +static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
>> +{
>> +	if (cqe->res < 0)
>> +		error(1, 0, "accept()");
>> +	if (connfd)
>> +		error(1, 0, "Unexpected second connection");
>> +
>> +	connfd = cqe->res;
>> +	add_recvzc(ring, connfd);
>> +}
>> +
>> +static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
>> +{
>> +	unsigned rq_mask = rq_ring.ring_entries - 1;
>> +	struct io_uring_zcrx_cqe *rcqe;
>> +	struct io_uring_zcrx_rqe *rqe;
>> +	struct io_uring_sqe *sqe;
>> +	uint64_t mask;
>> +	char *data;
>> +	ssize_t n;
>> +	int i;
>> +
>> +	if (cqe->res == 0 && cqe->flags == 0) {
>> +		stop = true;
>> +		return;
>> +	}
>> +
>> +	if (cqe->res < 0)
>> +		error(1, 0, "recvzc(): %d", cqe->res);
>> +
>> +	if (!(cqe->flags & IORING_CQE_F_MORE))
>> +		add_recvzc(ring, connfd);
>> +
>> +	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
>> +
>> +	n = cqe->res;
>> +	mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
>> +	data = (char *)area_ptr + (rcqe->off & mask);
>> +
>> +	for (i = 0; i < n; i++) {
>> +		if (*(data + i) != payload[(received + i)])
>> +			error(1, 0, "payload mismatch");
>> +	}
>> +	received += n;
>> +
>> +	rqe = &rq_ring.rqes[(rq_ring.rq_tail & rq_mask)];
>> +	rqe->off = (rcqe->off & IORING_ZCRX_AREA_MASK) | area_token;
>> +	rqe->len = cqe->res;
>> +	io_uring_smp_store_release(rq_ring.ktail, ++rq_ring.rq_tail);
>> +}
>> +
>> +static void server_loop(struct io_uring *ring)
>> +{
>> +	struct io_uring_cqe *cqe;
>> +	unsigned int count = 0;
>> +	unsigned int head;
>> +	int i, ret;
>> +
>> +	io_uring_submit_and_wait(ring, 1);
>> +
>> +	io_uring_for_each_cqe(ring, head, cqe) {
>> +		if (cqe->user_data == 1)
>> +			process_accept(ring, cqe);
>> +		else if (cqe->user_data == 2)
>> +			process_recvzc(ring, cqe);
>> +		else
>> +			error(1, 0, "unknown cqe");
>> +		count++;
>> +	}
>> +	io_uring_cq_advance(ring, count);
>> +}
>> +
>> +static void run_server(void)
>> +{
>> +	unsigned int flags = 0;
>> +	struct io_uring ring;
>> +	int fd, enable, ret;
>> +	uint64_t tstop;
>> +
>> +	fd = socket(cfg_family, SOCK_STREAM, 0);
>> +	if (fd == -1)
>> +		error(1, 0, "socket()");
>> +
>> +	enable = 1;
>> +	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &enable, sizeof(int));
>> +	if (ret < 0)
>> +		error(1, 0, "setsockopt(SO_REUSEADDR)");
>> +
>> +	ret = bind(fd, (const struct sockaddr *)&cfg_addr, sizeof(cfg_addr));
>> +	if (ret < 0)
>> +		error(1, 0, "bind()");
>> +
>> +	if (listen(fd, 1024) < 0)
>> +		error(1, 0, "listen()");
>> +
>> +	flags |= IORING_SETUP_COOP_TASKRUN;
>> +	flags |= IORING_SETUP_SINGLE_ISSUER;
>> +	flags |= IORING_SETUP_DEFER_TASKRUN;
>> +	flags |= IORING_SETUP_SUBMIT_ALL;
>> +	flags |= IORING_SETUP_CQE32;
>> +
>> +	io_uring_queue_init(512, &ring, flags);
>> +
>> +	setup_zcrx(&ring);
>> +
>> +	add_accept(&ring, fd);
>> +
>> +	tstop = gettimeofday_ms() + 5000;
>> +	while (!stop && gettimeofday_ms() < tstop)
>> +		server_loop(&ring);
>> +
>> +	if (!stop)
>> +		error(1, 0, "test failed\n");
>> +}
>> +
>> +static void run_client(void)
>> +{
>> +	ssize_t to_send = SEND_SIZE;
>> +	ssize_t sent = 0;
>> +	ssize_t chunk, res;
>> +	int fd;
>> +
>> +	fd = socket(cfg_family, SOCK_STREAM, 0);
>> +	if (fd == -1)
>> +		error(1, 0, "socket()");
>> +
>> +	if (connect(fd, (void *)&cfg_addr, cfg_alen))
>> +		error(1, 0, "connect()");
>> +
>> +	while (to_send) {
>> +		void *src = &payload[sent];
>> +
>> +		chunk = min_t(ssize_t, cfg_payload_len, to_send);
>> +		res = send(fd, src, chunk, 0);
>> +		if (res < 0)
>> +			error(1, 0, "send(): %d", sent);
>> +		sent += res;
>> +		to_send -= res;
>> +	}
>> +
>> +	close(fd);
>> +}
>> +
>> +static void usage(const char *filepath)
>> +{
>> +	error(1, 0, "Usage: %s (-4|-6) (-s|-c) -h<server_ip> -p<port> "
>> +		    "-l<payload_size> -i<ifname> -q<rxq_id>", filepath);
>> +}
>> +
>> +static void parse_opts(int argc, char **argv)
>> +{
>> +	const int max_payload_len = sizeof(payload) -
>> +				    sizeof(struct ipv6hdr) -
>> +				    sizeof(struct tcphdr) -
>> +				    40 /* max tcp options */;
>> +	struct sockaddr_in6 *addr6 = (void *) &cfg_addr;
>> +	struct sockaddr_in *addr4 = (void *) &cfg_addr;
>> +	char *addr = NULL;
>> +	int c;
>> +
>> +	if (argc <= 1)
>> +		usage(argv[0]);
>> +	cfg_payload_len = max_payload_len;
>> +
>> +	while ((c = getopt(argc, argv, "46sch:p:l:i:q:")) != -1) {
>> +		switch (c) {
>> +		case '4':
>> +			if (cfg_family != PF_UNSPEC)
>> +				error(1, 0, "Pass one of -4 or -6");
>> +			cfg_family = PF_INET;
>> +			cfg_alen = sizeof(struct sockaddr_in);
>> +			break;
>> +		case '6':
>> +			if (cfg_family != PF_UNSPEC)
>> +				error(1, 0, "Pass one of -4 or -6");
>> +			cfg_family = PF_INET6;
>> +			cfg_alen = sizeof(struct sockaddr_in6);
>> +			break;
>> +		case 's':
>> +			if (cfg_client)
>> +				error(1, 0, "Pass one of -s or -c");
>> +			cfg_server = 1;
>> +			break;
>> +		case 'c':
>> +			if (cfg_server)
>> +				error(1, 0, "Pass one of -s or -c");
>> +			cfg_client = 1;
>> +			break;
>> +		case 'h':
>> +			addr = optarg;
>> +			break;
>> +		case 'p':
>> +			cfg_port = strtoul(optarg, NULL, 0);
>> +			break;
>> +		case 'l':
>> +			cfg_payload_len = strtoul(optarg, NULL, 0);
>> +			break;
>> +		case 'i':
>> +			cfg_ifname = optarg;
>> +			break;
>> +		case 'q':
>> +			cfg_queue_id = strtoul(optarg, NULL, 0);
>> +			break;
>> +		}
>> +	}
>> +
>> +	if (cfg_server && addr)
>> +		error(1, 0, "Receiver cannot have -h specified");
>> +
>> +	switch (cfg_family) {
> 
> [..]
> 
>> +	case PF_INET:
>> +		memset(addr4, 0, sizeof(*addr4));
>> +		addr4->sin_family = AF_INET;
>> +		addr4->sin_port = htons(cfg_port);
>> +		addr4->sin_addr.s_addr = htonl(INADDR_ANY);
>> +
>> +		if (addr &&
>> +		    inet_pton(AF_INET, addr, &(addr4->sin_addr)) != 1)
>> +			error(1, 0, "ipv4 parse error: %s", addr);
>> +		break;
>> +	case PF_INET6:
>> +		memset(addr6, 0, sizeof(*addr6));
>> +		addr6->sin6_family = AF_INET6;
>> +		addr6->sin6_port = htons(cfg_port);
>> +		addr6->sin6_addr = in6addr_any;
>> +
>> +		if (addr &&
>> +		    inet_pton(AF_INET6, addr, &(addr6->sin6_addr)) != 1)
>> +			error(1, 0, "ipv6 parse error: %s", addr);
>> +		break;
> 
> nit: let's drop explicit af_inet support and use dual-stack af_inet6 sockets
> explicitly? Take a look at parse_address in
> tools/testing/selftests/drivers/net/hw/ncdevmem.c on how to
> transparently fallback to v4 (maybe even move that parsing function into
> some new networking_helpers.c lib similar to bpf subtree?).
> 
> (context: pure v4 environments are unlikely to exist at this point;
> anything that supports v6 can use v4-mapped-v6 addresses)
> 
>> +	default:
>> +		error(1, 0, "illegal domain");
>> +	}
>> +
>> +	if (cfg_payload_len > max_payload_len)
>> +		error(1, 0, "-l: payload exceeds max (%d)", max_payload_len);
>> +}
>> +
>> +int main(int argc, char **argv)
>> +{
>> +	const char *cfg_test = argv[argc - 1];
>> +	int i;
>> +
>> +	parse_opts(argc, argv);
>> +
>> +	for (i = 0; i < SEND_SIZE; i++)
>> +		payload[i] = 'a' + (i % 26);
>> +
>> +	if (cfg_server)
>> +		run_server();
>> +	else if (cfg_client)
>> +		run_client();
>> +
>> +	return 0;
>> +}
>> diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.py b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
>> new file mode 100755
>> index 000000000000..3998d0ad504f
>> --- /dev/null
>> +++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.py
>> @@ -0,0 +1,64 @@
>> +#!/usr/bin/env python3
>> +# SPDX-License-Identifier: GPL-2.0
>> +
>> +from os import path
>> +from lib.py import ksft_run, ksft_exit
>> +from lib.py import NetDrvEpEnv
>> +from lib.py import bkg, cmd, wait_port_listen
>> +
>> +
> 
> [..]
> 
>> +def _get_rx_ring_entries(cfg):
>> +    eth_cmd = "ethtool -g {} | awk '/RX:/ {{count++}} count == 2 {{print $2; exit}}'"
>> +    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
>> +    return int(res.stdout)
>> +
>> +
>> +def _get_combined_channels(cfg):
>> +    eth_cmd = "ethtool -l {} | awk '/Combined:/ {{count++}} count == 2 {{print $2; exit}}'"
>> +    res = cmd(eth_cmd.format(cfg.ifname), host=cfg.remote)
>> +    return int(res.stdout)
>> +
>> +
>> +def _set_flow_rule(cfg, chan):
>> +    eth_cmd = "ethtool -N {} flow-type tcp6 dst-port 9999 action {} | awk '{{print $NF}}'"
>> +    res = cmd(eth_cmd.format(cfg.ifname, chan), host=cfg.remote)
>> +    return int(res.stdout)
> 
> Most of these (except installing flow steering rule) can be done over
> ethtool ynl family. Should we try to move them over to YNL calls instead
> of shelling out to ethtool binary? There are some examples in rss_ctx.py
> on how to work with ethtool spec.
> 
> Same for setting/resetting number of queues below.

I wanted to use YNL, but these commands are run on the remote host and
it's currently challenging to use YNL there.

> 
> For the rest, there is also a ethtool() wrapper so you don't have to
> do cmd("ethtool ...") and can do ethtool("...").

SG, I will update to use ethtool() helper.

