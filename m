Return-Path: <io-uring+bounces-73-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FC57E5604
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 13:15:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9B777B20B62
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 12:15:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF47E16404;
	Wed,  8 Nov 2023 12:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b6Erl/ry"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B6317986
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 12:15:27 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2BA1BDA
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 04:15:26 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231108121524epoutp0479c3c20738ad250828f6660f85716693~VpOHlLC3j3264032640epoutp04d
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 12:15:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231108121524epoutp0479c3c20738ad250828f6660f85716693~VpOHlLC3j3264032640epoutp04d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1699445724;
	bh=gP0fgGTrxMWp/6TO61Wk1e7pHUD7PcvF5LNiKUYGv/Y=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=b6Erl/ryH6Fa7vmNkFGMKTQXhxjcv22zxXgqEfdRbuXAQdAyhclNYfbqWg+ZMuJoo
	 2NDkjis2VyEqC+RYjb/UO7/Bj2eFB0O0BUp/Ti0m6ujWGND5pY6fYvs58ZLVUQ6yZG
	 lpdDvMl/HiES9vypF2GfqlB5Ou7cJ+raDn6m0BLM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20231108121524epcas5p35a7760cfb03aa5880fb5330a226e31fb~VpOHH9WlU2851028510epcas5p3t;
	Wed,  8 Nov 2023 12:15:24 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4SQPDV3VdLz4x9Pp; Wed,  8 Nov
	2023 12:15:22 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	76.69.19369.ADB7B456; Wed,  8 Nov 2023 21:15:22 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231108121521epcas5p4998e20480cc82505cd013302f4a81ab5~VpOEj-q1W0944709447epcas5p4E;
	Wed,  8 Nov 2023 12:15:21 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231108121521epsmtrp1270c39d130cd87dd311b62bbf7d6d3c0~VpOEjX7NP3096130961epsmtrp1y;
	Wed,  8 Nov 2023 12:15:21 +0000 (GMT)
X-AuditID: b6c32a50-c99ff70000004ba9-0f-654b7bdacac2
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C1.16.08817.9DB7B456; Wed,  8 Nov 2023 21:15:21 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20231108121519epsmtip1fd7c1454f43b8d2b7707ac8ed7ab7e7b~VpODPoR_P2912329123epsmtip1o;
	Wed,  8 Nov 2023 12:15:19 +0000 (GMT)
Message-ID: <3e14f4c8-482d-df2c-f802-ebc74bd12664@samsung.com>
Date: Wed, 8 Nov 2023 17:45:19 +0530
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCHv2 1/4] block: bio-integrity: directly map user buffers
Content-Language: en-US
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org, axboe@kernel.dk,
	hch@lst.de, martin.petersen@oracle.com
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <ZUpS150ojGIJ-bkP@kbusch-mbp.dhcp.thefacebook.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmuu6tau9Ug08rJC1W3+1ns1i5+iiT
	xbvWcywWkw5dY7Q4c3Uhi8XeW9oW85c9ZbdYfvwfkwOHx+WzpR6bVnWyeWxeUu+x+2YDm8e5
	ixUeH5/eYvH4vEkugD0q2yYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
	VsnFJ0DXLTMH6CIlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5xia1SakFKToFJgV5xYm5xaV66
	Xl5qiZWhgYGRKVBhQnbGpMUvGAte6FdcuL2AsYHxinwXIyeHhICJxIlZp5m7GLk4hAT2MEpc
	uPOVBcL5xCgxa94SRgjnG6PEljNdbDAt07/PhUrsZZTY+vkBVMtbRondp6ewglTxCthJfJnx
	jBnEZhFQkbi7fTJUXFDi5MwnLCC2qECSxK+rcxhBbGEBL4nbjd/BapgFxCVuPZnPBGKLCChL
	3J0/kxVkAbPAVkaJDa/mAjVzcLAJaEpcmFwKUsMpYC9xvvkSE0SvvMT2t3PAHpIQmMsh8enZ
	WXaIs10k+k68Z4GwhSVeHd8CFZeSeNnfBmUnS1yaeY4Jwi6ReLznIJRtL9F6qp8ZZC8z0N71
	u/QhdvFJ9P5+wgQSlhDglehoE4KoVpS4N+kpK4QtLvFwxhIo20Pi8cOrbJCw6maW+HXkDdME
	RoVZSMEyC8n7s5C8Mwth8wJGllWMUqkFxbnpqcmmBYa6eanl8ChPzs/dxAhOsloBOxhXb/ir
	d4iRiYPxEKMEB7OSCO9fe49UId6UxMqq1KL8+KLSnNTiQ4ymwAiayCwlmpwPTPN5JfGGJpYG
	JmZmZiaWxmaGSuK8r1vnpggJpCeWpGanphakFsH0MXFwSjUwyTx4W3qb3+W5+BWjKS6nurXW
	mF2zafrS/sE+NLyQ0Xj68c96K3fMvJk9debBNQ/Pb73qq3re4cAPTq9rJaVHLgmu+T5xzlw/
	kadFB/lWlCx72xSY8Ytpa4HcURMbprP+JqZJb+V/OL6qYWuU/crocMns/+Evqi82VyT7JzCH
	Fma8kZ0vN/dgziGDaSabb7w3jBGf1/XAZuKMmqzj32zsLN4e2Kww7f3bhQaLA0OWL2079N10
	jqWCPgv/3DSlRLVX06WuHBVfw+X9hXdCqMl8zic3eX+3fX79Nbcn49zFib2hXg90Zj/grvu2
	pmedymOWnTaP3GR1UhRiXQXFDsf/2RJxqyVSiZdTfoPkxjAPIyWW4oxEQy3mouJEAEDgmeA7
	BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmkeLIzCtJLcpLzFFi42LZdlhJTvdmtXeqwZxT7Bar7/azWaxcfZTJ
	4l3rORaLSYeuMVqcubqQxWLvLW2L+cueslssP/6PyYHD4/LZUo9NqzrZPDYvqffYfbOBzePc
	xQqPj09vsXh83iQXwB7FZZOSmpNZllqkb5fAlTFp8QvGghf6FRduL2BsYLwi38XIySEhYCIx
	/ftcxi5GLg4hgd2MEtPPv2OBSIhLNF/7wQ5hC0us/PecHaLoNaPEu+4JrCAJXgE7iS8znjGD
	2CwCKhJ3t0+GigtKnJz5BGyQqECSxJ77jUwgtrCAl8Ttxu9gNcxAC249mQ8WFxFQlrg7fyYr
	yAJmga2MEstP7WWB2NbNLDH94COgDAcHm4CmxIXJpSANnAL2EuebLzFBDDKT6NraxQhhy0ts
	fzuHeQKj0Cwkd8xCsm8WkpZZSFoWMLKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQI
	jictrR2Me1Z90DvEyMTBeIhRgoNZSYT3r71HqhBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeb697
	U4QE0hNLUrNTUwtSi2CyTBycUg1MG619c9/9nHDx6wPFyIS7u410wio+l+dtu27Vn3cg9rfr
	Q8fAqYs1L+9qf83xumJntj+vZdVyLu7dQe8emQf7nZ0rNeE9+3wmpWBGwZ/lTcHnwy8r/jdN
	mfyI2dcn9b2ImGD3K8XwmQV1ZZO2BUWY3Jt2aoLGT7kT+kzKIaJ3jQ1vshWHTF3+/twah/Rr
	DKcdfmXFb5skY+wqU5abefK3ExPPrUnXEvo1C39oikcfWvjB4f9z37io8MDXS47Nu7WYdSkv
	g8tCL48dPM5vXwaurFos3F39VVuvef63M3s2Wu+5ebH7nktKXYzuV7sFm4M3ZD6LWsSjcm1B
	4czI21161YlX/XeWBd5jnh76ZtMVJZbijERDLeai4kQAVWF3YxYDAAA=
X-CMS-MailID: 20231108121521epcas5p4998e20480cc82505cd013302f4a81ab5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6
References: <20231027181929.2589937-1-kbusch@meta.com>
	<CGME20231027182010epcas5p36bcf271f93f821055206b2e04b3019a6@epcas5p3.samsung.com>
	<20231027181929.2589937-2-kbusch@meta.com>
	<40ac82f5-ce1b-6f49-3609-1aff496ae241@samsung.com>
	<ZUkAH258Ts0caQ5W@kbusch-mbp.dhcp.thefacebook.com>
	<1067f03f-e89b-4fc8-58bb-0b83b6c5c91d@samsung.com>
	<ZUpS150ojGIJ-bkP@kbusch-mbp.dhcp.thefacebook.com>

On 11/7/2023 8:38 PM, Keith Busch wrote:
> On Tue, Nov 07, 2023 at 03:55:14PM +0530, Kanchan Joshi wrote:
>> On 11/6/2023 8:32 PM, Keith Busch wrote:
>>> On Mon, Nov 06, 2023 at 11:18:03AM +0530, Kanchan Joshi wrote:
>>>> On 10/27/2023 11:49 PM, Keith Busch wrote:
>>>>> +	for (i = 0; i < nr_vecs; i = j) {
>>>>> +		size_t size = min_t(size_t, bytes, PAGE_SIZE - offs);
>>>>> +		struct folio *folio = page_folio(pages[i]);
>>>>> +
>>>>> +		bytes -= size;
>>>>> +		for (j = i + 1; j < nr_vecs; j++) {
>>>>> +			size_t next = min_t(size_t, PAGE_SIZE, bytes);
>>>>> +
>>>>> +			if (page_folio(pages[j]) != folio ||
>>>>> +			    pages[j] != pages[j - 1] + 1)
>>>>> +				break;
>>>>> +			unpin_user_page(pages[j]);
>>>>
>>>> Is this unpin correct here?
>>>
>>> Should be. The pages are bound to the folio, so this doesn't really
>>> unpin the user page. It just drops a reference, and the folio holds the
>>> final reference to the contiguous pages, which is released on
>>> completion.
>>
>> But the completion is still going to see multiple pages and not one
>> (folio). The bip_for_each_vec loop is going to drop the reference again.
>> I suspect it is not folio-aware.
> 
> The completion unpins once per bvec, not individual pages. The setup
> creates multipage bvecs with only one pin remaining per bvec for all of
> the bvec's pages. If a page can't be merged into the current bvec, then
> that page is not unpinned and becomes the first page of to the next
> bvec.
> 

Here is a test program [2] that creates this scenario.
Single 8KB+16b read on a 4KB+8b formatted namespace. It prepares 
meta-buffer out of a huge-page in a way that it spans two regular 4K pages.
With this, I see more unpins than expected.

And I had added this [1] also on top of your patch.

[1]
@@ -339,7 +367,22 @@ int bio_integrity_map_user(struct bio *bio, void 
__user *ubuf, unsigned int len,
         memcpy(bip->bip_vec, bvec, folios * sizeof(*bvec));
         if (bvec != stack_vec)
                 kfree(bvec);
+       // quick fix for completion
+       bip->bip_vcnt = folios;
+       bip->bip_iter.bi_size = len;


[2]
#define _GNU_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <liburing.h>
#include <libnvme.h>

#define DEV             "/dev/ng0n1"
#define NSID            1
#define DBCNT           2
#define DATA_BUFLEN     (4096 * DBCNT)
#define OFFSET          0
#define LBA_SHIFT       12

/* This assumes 4K + 8b lba format */
#define MD_BUFLEN       (8 * DBCNT)
#define MD_OFFSET       (4096 - 8)
#define HP_SIZE         (2*2*1024*1024) /*Two 2M pages*/

#define APPTAG_MASK     (0xFFFF)
#define APPTAG          (0x8888)

void *alloc_meta_buf_hp()
{
         void *ptr;

         ptr = mmap(NULL, HP_SIZE, PROT_READ | PROT_WRITE,
                         MAP_PRIVATE|MAP_ANONYMOUS|MAP_HUGETLB,
                         -1, 0);
         if (ptr == MAP_FAILED)
                 return NULL;
         return ptr;
}

void free_meta_buf(void *ptr)
{
         munmap(ptr, HP_SIZE);
}

int main()
{
         struct io_uring ring;
         struct io_uring_cqe *cqe;
         struct io_uring_sqe *sqe;
         struct io_uring_params p = { };
         int fd, ret;
         struct nvme_uring_cmd *cmd;
         void *buffer, *md_buf;
         __u64 slba;
         __u16 nlb;

         ret = posix_memalign(&buffer, DATA_BUFLEN, DATA_BUFLEN);
         if (ret) {
                 fprintf(stderr, "data buffer allocation failed: %d\n", 
ret);
                 return 1;
         }
         memset(buffer, 'x', DATA_BUFLEN);

         md_buf = alloc_meta_buf_hp();
         if (!md_buf) {
                 fprintf(stderr, "meta buffer allocation failed: %d\n", 
ret);
                 return 1;
         }

         p.flags = IORING_SETUP_CQE32 | IORING_SETUP_SQE128;
         ret = io_uring_queue_init_params(4, &ring, &p);
         if (ret) {
                 fprintf(stderr, "ring create failed: %d\n", ret);
                 return 1;
         }

         fd = open(DEV, O_RDWR);
         if (fd < 0) {
                 perror("file open");
                 exit(1);
         }

         sqe = io_uring_get_sqe(&ring);
         io_uring_prep_read(sqe, fd, buffer, DATA_BUFLEN, OFFSET);
         sqe->cmd_op = NVME_URING_CMD_IO;
         sqe->opcode = IORING_OP_URING_CMD;
         sqe->user_data = 1234;

         cmd = (struct nvme_uring_cmd *)sqe->cmd;
         memset(cmd, 0, sizeof(struct nvme_uring_cmd));
         cmd->opcode = nvme_cmd_read;
         cmd->addr = (__u64)(uintptr_t)buffer;
         cmd->data_len = DATA_BUFLEN;
         cmd->nsid = NSID;

         slba = OFFSET >> LBA_SHIFT;
         nlb = (DATA_BUFLEN >> LBA_SHIFT) - 1;
         cmd->cdw10 = slba & 0xffffffff;
         cmd->cdw11 = slba >> 32;
         cmd->cdw12 = nlb;
         /* set the pract and prchk (Guard, App, RefTag) bits in cdw12 */
         //cmd->cdw12 |= 15 << 26;
         cmd->cdw12 |= 7 << 26;

         cmd->metadata = ((__u64)(uintptr_t)md_buf) + MD_OFFSET;
         cmd->metadata_len = MD_BUFLEN;

         /* reftag */
         cmd->cdw14 = (__u32)slba;
         /* apptag mask and apptag */
         cmd->cdw15 = APPTAG_MASK << 16 | APPTAG;

         ret = io_uring_submit(&ring);
         if (ret != 1) {
                 fprintf(stderr, "submit got %d, wanted %d\n", ret, 1);
                 goto err;
         }
         ret = io_uring_wait_cqe(&ring, &cqe);
         if (ret) {
                 fprintf(stderr, "wait_cqe=%d\n", ret);
                 goto err;
         }
         if (cqe->res != 0) {
                 fprintf(stderr, "cqe res %d, wanted success\n", cqe->res);
                 goto err;
         }

         io_uring_cqe_seen(&ring, cqe);
         free_meta_buf(md_buf);
         close(fd);
         io_uring_queue_exit(&ring);
         return 0;
err:
         if (fd != -1)
                 close(fd);
         io_uring_queue_exit(&ring);
         return 1;
}



