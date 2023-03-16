Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759AE6BCF63
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 13:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjCPM15 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 08:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCPM14 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 08:27:56 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598D61ADF3;
        Thu, 16 Mar 2023 05:27:54 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w9so7003527edc.3;
        Thu, 16 Mar 2023 05:27:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678969673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tJ5R57Y2Elyh+HB9EXDiUqkh0ZoyoIWbdRTvpuK8EAM=;
        b=U613lsKic7pTBTfQHDhgvpebiOSxRkmrIli1y2Xcwkd+OG7h0u8tgsas/GkGMrNZ6y
         aDSo+21dEl6jSu0ie23kLPPHsPb3qX3yv3sSrVgShAuBhydPyfrU/XXbuRZaC47Rq6w7
         ohlzmOWlDFutLpwNPb2GV/ZFySi8tWl8Q4LbOYzWZliy3fe7DjEcFfvkuiQEc8c1n6IC
         /9hDj7ycs7hNyd2JIdbGIyygH5rN4+LeXbrqxhz1A9KWPsOzOqdhmNQbvpVkZ5jtaQEG
         tVaQVSI1MXKcxICBczL0Vb4236YvRpxPIunIF+stdDnfYwHJx0+/okAQZ3xPSaOa6Zu2
         MBpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678969673;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tJ5R57Y2Elyh+HB9EXDiUqkh0ZoyoIWbdRTvpuK8EAM=;
        b=KTaaCLObqCTRc3nPPszwc69ArUr4dWwsRaWabPR97yCf+Oy3jNgwF4C6OGYE4tfkoA
         hqSYVFdqdoiKLqk4WEV6gqvOW7mEHyUf1MJp+sDJ9T3wcUWwueI0DormuKJBCthwPrDB
         JuaxbR+113DHj5BM4DNv/7wer3swvEfJlaLqvQsuxNf9FrYKQ5YeqdZ1kOzHCST1PAYu
         mzLQ8vbvcBZPbohEXQXLvLEpJVhGV5H9xPszBPUkKiDogfcNaDbmInZADOEv4l6pNDcT
         d7jjIH8FwSonq4PIMy9belYROClbihV+dOLxWhBp5wSeGuwZzKAFw265d5JO72Q7puNi
         5mug==
X-Gm-Message-State: AO0yUKVBFS+klC8fHlXvMT/nWJz78wy/Mgq5RB9sq5hDRRnfDNczkG/c
        Ne5cUdqWnJm5VQsqItYNG2fRPnuva98=
X-Google-Smtp-Source: AK7set/9BCRnGxS0ZGumYYHXTVDXPnzp+cYaYl9NbmnAk3Cyz9GNslKCBSpeZtR2gZrgHBPMYYy+9Q==
X-Received: by 2002:aa7:d756:0:b0:4fa:315a:cb55 with SMTP id a22-20020aa7d756000000b004fa315acb55mr6836177eds.21.1678969672713;
        Thu, 16 Mar 2023 05:27:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id z22-20020a170906271600b0091f58083a15sm3803462ejc.175.2023.03.16.05.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 05:27:52 -0700 (PDT)
Message-ID: <151c3814-4bff-91d4-da3f-3fe8d0370285@gmail.com>
Date:   Thu, 16 Mar 2023 12:26:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH for-next 4/4] io_uring/rsrc: optimise registered huge
 pages
Content-Language: en-US
To:     Mark Rutland <mark.rutland@arm.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1677041932.git.asml.silence@gmail.com>
 <757a0c399774f23df5dbfe2e0cc79f7ea432b04c.1677041932.git.asml.silence@gmail.com>
 <ZBMHphP4qaaKqJqL@FVFF77S0Q05N>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZBMHphP4qaaKqJqL@FVFF77S0Q05N>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/16/23 12:12, Mark Rutland wrote:
> Hi,
> 
> Since v6.3-rc1, when fuzzing arm64 with Syzkaller, I see a bunch of bad page
> state splats with either "nonzero pincount" or "nonzero compound_pincount", and
> bisecting led me to this patch / commit:
> 
>    57bebf807e2abcf8 ("io_uring/rsrc: optimise registered huge pages")

We'll take a look, thanks for letting know


> 
> The splats look like:
> 
> | BUG: Bad page state in process kworker/u8:0  pfn:5c001
> | page:00000000bfda61c8 refcount:0 mapcount:0 mapping:0000000000000000 index:0x20001 pfn:0x5c001
> | head:0000000011409842 order:9 entire_mapcount:0 nr_pages_mapped:0 pincount:1
> | anon flags: 0x3fffc00000b0004(uptodate|head|mappedtodisk|swapbacked|node=0|zone=0|lastcpupid=0xffff)
> | raw: 03fffc0000000000 fffffc0000700001 ffffffff00700903 0000000100000000
> | raw: 0000000000000200 0000000000000000 00000000ffffffff 0000000000000000
> | head: 03fffc00000b0004 dead000000000100 dead000000000122 ffff00000a809dc1
> | head: 0000000000020000 0000000000000000 00000000ffffffff 0000000000000000
> | page dumped because: nonzero pincount
> | CPU: 3 PID: 9 Comm: kworker/u8:0 Not tainted 6.3.0-rc2-00001-gc6811bf0cd87 #1
> | Hardware name: linux,dummy-virt (DT)
> | Workqueue: events_unbound io_ring_exit_work
> | Call trace:
> |  dump_backtrace+0x13c/0x208
> |  show_stack+0x34/0x58
> |  dump_stack_lvl+0x150/0x1a8
> |  dump_stack+0x20/0x30
> |  bad_page+0xec/0x238
> |  free_tail_pages_check+0x280/0x350
> |  free_pcp_prepare+0x60c/0x830
> |  free_unref_page+0x50/0x498
> |  free_compound_page+0xcc/0x100
> |  free_transhuge_page+0x1f0/0x2b8
> |  destroy_large_folio+0x80/0xc8
> |  __folio_put+0xc4/0xf8
> |  gup_put_folio+0xd0/0x250
> |  unpin_user_page+0xcc/0x128
> |  io_buffer_unmap+0xec/0x2c0
> |  __io_sqe_buffers_unregister+0xa4/0x1e0
> |  io_ring_exit_work+0x68c/0x1188
> |  process_one_work+0x91c/0x1a58
> |  worker_thread+0x48c/0xe30
> |  kthread+0x278/0x2f0
> |  ret_from_fork+0x10/0x20
> 
> Syzkaller gave me a reliable C reproducer, which I used to bisect (note:
> DEBUG_VM needs to be selected):
> 
> | // autogenerated by syzkaller (https://github.com/google/syzkaller)
> |
> | #define _GNU_SOURCE
> |
> | #include <endian.h>
> | #include <stdint.h>
> | #include <stdio.h>
> | #include <stdlib.h>
> | #include <string.h>
> | #include <sys/mman.h>
> | #include <sys/syscall.h>
> | #include <sys/types.h>
> | #include <unistd.h>
> |
> | #ifndef __NR_io_uring_register
> | #define __NR_io_uring_register 427
> | #endif
> | #ifndef __NR_io_uring_setup
> | #define __NR_io_uring_setup 425
> | #endif
> | #ifndef __NR_mmap
> | #define __NR_mmap 222
> | #endif
> |
> | #define SIZEOF_IO_URING_SQE 64
> | #define SIZEOF_IO_URING_CQE 16
> | #define SQ_HEAD_OFFSET 0
> | #define SQ_TAIL_OFFSET 64
> | #define SQ_RING_MASK_OFFSET 256
> | #define SQ_RING_ENTRIES_OFFSET 264
> | #define SQ_FLAGS_OFFSET 276
> | #define SQ_DROPPED_OFFSET 272
> | #define CQ_HEAD_OFFSET 128
> | #define CQ_TAIL_OFFSET 192
> | #define CQ_RING_MASK_OFFSET 260
> | #define CQ_RING_ENTRIES_OFFSET 268
> | #define CQ_RING_OVERFLOW_OFFSET 284
> | #define CQ_FLAGS_OFFSET 280
> | #define CQ_CQES_OFFSET 320
> |
> | struct io_sqring_offsets {
> | 	uint32_t head;
> | 	uint32_t tail;
> | 	uint32_t ring_mask;
> | 	uint32_t ring_entries;
> | 	uint32_t flags;
> | 	uint32_t dropped;
> | 	uint32_t array;
> | 	uint32_t resv1;
> | 	uint64_t resv2;
> | };
> |
> | struct io_cqring_offsets {
> | 	uint32_t head;
> | 	uint32_t tail;
> | 	uint32_t ring_mask;
> | 	uint32_t ring_entries;
> | 	uint32_t overflow;
> | 	uint32_t cqes;
> | 	uint64_t resv[2];
> | };
> |
> | struct io_uring_params {
> | 	uint32_t sq_entries;
> | 	uint32_t cq_entries;
> | 	uint32_t flags;
> | 	uint32_t sq_thread_cpu;
> | 	uint32_t sq_thread_idle;
> | 	uint32_t features;
> | 	uint32_t resv[4];
> | 	struct io_sqring_offsets sq_off;
> | 	struct io_cqring_offsets cq_off;
> | };
> |
> | #define IORING_OFF_SQ_RING 0
> | #define IORING_OFF_SQES 0x10000000ULL
> |
> | static long syz_io_uring_setup(volatile long a0, volatile long a1, volatile long a2, volatile long a3, volatile long a4, volatile long a5)
> | {
> | 	uint32_t entries = (uint32_t)a0;
> | 	struct io_uring_params* setup_params = (struct io_uring_params*)a1;
> | 	void* vma1 = (void*)a2;
> | 	void* vma2 = (void*)a3;
> | 	void** ring_ptr_out = (void**)a4;
> | 	void** sqes_ptr_out = (void**)a5;
> | 	uint32_t fd_io_uring = syscall(__NR_io_uring_setup, entries, setup_params);
> | 	uint32_t sq_ring_sz = setup_params->sq_off.array + setup_params->sq_entries * sizeof(uint32_t);
> | 	uint32_t cq_ring_sz = setup_params->cq_off.cqes + setup_params->cq_entries * SIZEOF_IO_URING_CQE;
> | 	uint32_t ring_sz = sq_ring_sz > cq_ring_sz ? sq_ring_sz : cq_ring_sz;
> | 	*ring_ptr_out = mmap(vma1, ring_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQ_RING);
> | 	uint32_t sqes_sz = setup_params->sq_entries * SIZEOF_IO_URING_SQE;
> | 	*sqes_ptr_out = mmap(vma2, sqes_sz, PROT_READ | PROT_WRITE, MAP_SHARED | MAP_POPULATE | MAP_FIXED, fd_io_uring, IORING_OFF_SQES);
> | 	return fd_io_uring;
> | }
> |
> | uint64_t r[1] = {0xffffffffffffffff};
> |
> | int main(void)
> | {
> | 		syscall(__NR_mmap, 0x1ffff000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> | 	syscall(__NR_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x32ul, -1, 0ul);
> | 	syscall(__NR_mmap, 0x21000000ul, 0x1000ul, 0ul, 0x32ul, -1, 0ul);
> | 				intptr_t res = 0;
> | *(uint32_t*)0x20000684 = 0;
> | *(uint32_t*)0x20000688 = 0;
> | *(uint32_t*)0x2000068c = 0;
> | *(uint32_t*)0x20000690 = 0;
> | *(uint32_t*)0x20000698 = -1;
> | memset((void*)0x2000069c, 0, 12);
> | 	res = -1;
> | res = syz_io_uring_setup(0x2fd6, 0x20000680, 0x20ffd000, 0x20ffc000, 0x20000700, 0x20000740);
> | 	if (res != -1)
> | 		r[0] = res;
> | *(uint64_t*)0x20002840 = 0;
> | *(uint64_t*)0x20002848 = 0;
> | *(uint64_t*)0x20002850 = 0x20000840;
> | *(uint64_t*)0x20002858 = 0x1000;
> | 	syscall(__NR_io_uring_register, r[0], 0ul, 0x20002840ul, 2ul);
> | 	return 0;
> | }
> 
> Thanks,
> Mark.
> 
> On Wed, Feb 22, 2023 at 02:36:51PM +0000, Pavel Begunkov wrote:
>> When registering huge pages, internally io_uring will split them into
>> many PAGE_SIZE bvec entries. That's bad for performance as drivers need
>> to eventually dma-map the data and will do it individually for each bvec
>> entry. Coalesce huge pages into one large bvec.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/rsrc.c | 38 ++++++++++++++++++++++++++++++++------
>>   1 file changed, 32 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index ebbd2cea7582..aab1bc6883e9 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -1210,6 +1210,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>>   	unsigned long off;
>>   	size_t size;
>>   	int ret, nr_pages, i;
>> +	struct folio *folio;
>>   
>>   	*pimu = ctx->dummy_ubuf;
>>   	if (!iov->iov_base)
>> @@ -1224,6 +1225,21 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>>   		goto done;
>>   	}
>>   
>> +	/* If it's a huge page, try to coalesce them into a single bvec entry */
>> +	if (nr_pages > 1) {
>> +		folio = page_folio(pages[0]);
>> +		for (i = 1; i < nr_pages; i++) {
>> +			if (page_folio(pages[i]) != folio) {
>> +				folio = NULL;
>> +				break;
>> +			}
>> +		}
>> +		if (folio) {
>> +			folio_put_refs(folio, nr_pages - 1);
>> +			nr_pages = 1;
>> +		}
>> +	}
>> +
>>   	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
>>   	if (!imu)
>>   		goto done;
>> @@ -1236,6 +1252,17 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>>   
>>   	off = (unsigned long) iov->iov_base & ~PAGE_MASK;
>>   	size = iov->iov_len;
>> +	/* store original address for later verification */
>> +	imu->ubuf = (unsigned long) iov->iov_base;
>> +	imu->ubuf_end = imu->ubuf + iov->iov_len;
>> +	imu->nr_bvecs = nr_pages;
>> +	*pimu = imu;
>> +	ret = 0;
>> +
>> +	if (folio) {
>> +		bvec_set_page(&imu->bvec[0], pages[0], size, off);
>> +		goto done;
>> +	}
>>   	for (i = 0; i < nr_pages; i++) {
>>   		size_t vec_len;
>>   
>> @@ -1244,12 +1271,6 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
>>   		off = 0;
>>   		size -= vec_len;
>>   	}
>> -	/* store original address for later verification */
>> -	imu->ubuf = (unsigned long) iov->iov_base;
>> -	imu->ubuf_end = imu->ubuf + iov->iov_len;
>> -	imu->nr_bvecs = nr_pages;
>> -	*pimu = imu;
>> -	ret = 0;
>>   done:
>>   	if (ret)
>>   		kvfree(imu);
>> @@ -1364,6 +1385,11 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>>   		const struct bio_vec *bvec = imu->bvec;
>>   
>>   		if (offset <= bvec->bv_len) {
>> +			/*
>> +			 * Note, huge pages buffers consists of one large
>> +			 * bvec entry and should always go this way. The other
>> +			 * branch doesn't expect non PAGE_SIZE'd chunks.
>> +			 */
>>   			iter->bvec = bvec;
>>   			iter->nr_segs = bvec->bv_len;
>>   			iter->count -= offset;
>> -- 
>> 2.39.1
>>
>>

-- 
Pavel Begunkov
