Return-Path: <io-uring+bounces-101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB9C7F15A2
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 15:26:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8F732824EE
	for <lists+io-uring@lfdr.de>; Mon, 20 Nov 2023 14:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776821C694;
	Mon, 20 Nov 2023 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lCuHZB77"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19189116
	for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 06:26:24 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-40838915cecso16485035e9.2
        for <io-uring@vger.kernel.org>; Mon, 20 Nov 2023 06:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700490382; x=1701095182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NomKBH3ad1krxRctVgfTOQc0+gcqtboycO+iHQgiTPg=;
        b=lCuHZB77jN37UsE8XPUkfLjdrZe39FjET7Hd9AiG8hcDYkkoP09ilN+lPCwjxi/pqp
         AoyDpjvBsOjNNOKhhrhflhWOeCn1yrQNPGT3y97tmBBuo49XInlau326yibdSwRgBL7E
         IhgD57iKIn/XYNltla/MfXQG5VRW0VbcmSzw6m9n2FjxVaIAy7wZ7n6lvuXwOattgchI
         VN3WkHw8T3CzZKtzzOd+s9c7dd3gVHTolecQRb3SfMORJlRgC35Ffg0IgjAvsqKcPPmF
         b4EXcxwE6u7WZUfgTbW1fJyR0dBKN8EctCN+no9cMZK+4j6eLgUNrCUPrJoc1Sf2OSpD
         OPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700490382; x=1701095182;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NomKBH3ad1krxRctVgfTOQc0+gcqtboycO+iHQgiTPg=;
        b=VRkUIt/U59jEtxBijaEjUNdLZm0FJoVXBb0kddDldikbBaUWpnteELDh2Edn/3AnC0
         4NnjyeHDU8NgYlA+VvgRPMnYRfckm8BCI7QCa3b6/tulmE45PxAbql3xpeMIrtO/tbON
         0Bu0tXo53CbWk1lNXK56ba6/S6jTOgfbnLouWE2eFTL8oLb2AXuKW5bCN4ocB8M/Jqfg
         yw/luUSthzTW7BB/bwtB+w8EJUILTQj/t9hrHUbvx5+iz9nVj+AY9l1wI15mT4PEUYrQ
         d3b8naIWHI/IOndgBVzWYXvawlG+6+/b3tpw/kpeoGT03KCsK2qWkoj1CcpVYzpcSb9g
         MY4Q==
X-Gm-Message-State: AOJu0Ywu6COcZWyXAIwxtGu+mhBnbv4bzjvmhP79/AKm2Q8WO/RhI9TC
	kaV5rRAwVafNC/6kAXL72dg+Lg==
X-Google-Smtp-Source: AGHT+IGB99nwec+VXB9rjDH20Q4RTidyNZGyt6kb7Y5dXyW4S5iB60YWmNWJnZvLTgWjKWw2NsBtgw==
X-Received: by 2002:a5d:47a1:0:b0:332:c514:640e with SMTP id 1-20020a5d47a1000000b00332c514640emr3133700wrb.69.1700490382419;
        Mon, 20 Nov 2023 06:26:22 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id f12-20020adff44c000000b003313e4dddecsm11286289wrp.108.2023.11.20.06.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 06:26:22 -0800 (PST)
From: Dan Carpenter <dan.carpenter@linaro.org>
X-Google-Original-From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Mon, 20 Nov 2023 09:26:19 -0500
To: oe-kbuild@lists.linux.dev, Xiaobing Li <xiaobing.li@samsung.com>,
	axboe@kernel.dk, asml.silence@gmail.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, cliang01.li@samsung.com,
	xue01.he@samsung.com, Xiaobing Li <xiaobing.li@samsung.com>
Subject: Re: [PATCH v3] io_uring: Statistics of the true utilization of sq
 threads.
Message-ID: <50ec567f-6b79-42ea-bf2c-2c9b2ecb427d@suswa.mountain>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115121839.12556-1-xiaobing.li@samsung.com>

Hi Xiaobing,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Xiaobing-Li/io_uring-Statistics-of-the-true-utilization-of-sq-threads/20231115-211954
base:   linus/master
patch link:    https://lore.kernel.org/r/20231115121839.12556-1-xiaobing.li%40samsung.com
patch subject: [PATCH v3] io_uring: Statistics of the true utilization of sq threads.
config: x86_64-randconfig-161-20231115 (https://download.01.org/0day-ci/archive/20231116/202311160629.h4GrebJh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20231116/202311160629.h4GrebJh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <error27@gmail.com>
| Closes: https://lore.kernel.org/r/202311160629.h4GrebJh-lkp@intel.com/

smatch warnings:
io_uring/fdinfo.c:138 io_uring_show_fdinfo() warn: variable dereferenced before check 'ctx' (see line 57)
io_uring/fdinfo.c:144 io_uring_show_fdinfo() error: we previously assumed 'sq' could be null (see line 141)

vim +/ctx +138 io_uring/fdinfo.c

3aaf22b62a9270 Jens Axboe     2023-07-10   53  __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
a4ad4f748ea962 Jens Axboe     2022-05-25   54  {
3aaf22b62a9270 Jens Axboe     2023-07-10   55  	struct io_ring_ctx *ctx = f->private_data;
a4ad4f748ea962 Jens Axboe     2022-05-25   56  	struct io_overflow_cqe *ocqe;
a4ad4f748ea962 Jens Axboe     2022-05-25  @57  	struct io_rings *r = ctx->rings;
                                                                     ^^^^^^^^^^
Tons of unchecked dereferences so ctx can't be NULL.

a4ad4f748ea962 Jens Axboe     2022-05-25   58  	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
a4ad4f748ea962 Jens Axboe     2022-05-25   59  	unsigned int sq_head = READ_ONCE(r->sq.head);
a4ad4f748ea962 Jens Axboe     2022-05-25   60  	unsigned int sq_tail = READ_ONCE(r->sq.tail);
a4ad4f748ea962 Jens Axboe     2022-05-25   61  	unsigned int cq_head = READ_ONCE(r->cq.head);
a4ad4f748ea962 Jens Axboe     2022-05-25   62  	unsigned int cq_tail = READ_ONCE(r->cq.tail);
a4ad4f748ea962 Jens Axboe     2022-05-25   63  	unsigned int cq_shift = 0;
3b8fdd1dc35e39 Jens Axboe     2022-09-11   64  	unsigned int sq_shift = 0;
a4ad4f748ea962 Jens Axboe     2022-05-25   65  	unsigned int sq_entries, cq_entries;
7644b1a1c9a7ae Jens Axboe     2023-10-21   66  	int sq_pid = -1, sq_cpu = -1;
5b1b61674371b7 Xiaobing Li    2023-11-15   67  	int sq_busy = 0;
a4ad4f748ea962 Jens Axboe     2022-05-25   68  	bool has_lock;
a4ad4f748ea962 Jens Axboe     2022-05-25   69  	unsigned int i;
a4ad4f748ea962 Jens Axboe     2022-05-25   70  
4f731705cc1f15 Jens Axboe     2022-09-11   71  	if (ctx->flags & IORING_SETUP_CQE32)
a4ad4f748ea962 Jens Axboe     2022-05-25   72  		cq_shift = 1;
3b8fdd1dc35e39 Jens Axboe     2022-09-11   73  	if (ctx->flags & IORING_SETUP_SQE128)
3b8fdd1dc35e39 Jens Axboe     2022-09-11   74  		sq_shift = 1;
a4ad4f748ea962 Jens Axboe     2022-05-25   75  
a4ad4f748ea962 Jens Axboe     2022-05-25   76  	/*
a4ad4f748ea962 Jens Axboe     2022-05-25   77  	 * we may get imprecise sqe and cqe info if uring is actively running
a4ad4f748ea962 Jens Axboe     2022-05-25   78  	 * since we get cached_sq_head and cached_cq_tail without uring_lock
a4ad4f748ea962 Jens Axboe     2022-05-25   79  	 * and sq_tail and cq_head are changed by userspace. But it's ok since
a4ad4f748ea962 Jens Axboe     2022-05-25   80  	 * we usually use these info when it is stuck.
a4ad4f748ea962 Jens Axboe     2022-05-25   81  	 */
a4ad4f748ea962 Jens Axboe     2022-05-25   82  	seq_printf(m, "SqMask:\t0x%x\n", sq_mask);
a4ad4f748ea962 Jens Axboe     2022-05-25   83  	seq_printf(m, "SqHead:\t%u\n", sq_head);
a4ad4f748ea962 Jens Axboe     2022-05-25   84  	seq_printf(m, "SqTail:\t%u\n", sq_tail);
a4ad4f748ea962 Jens Axboe     2022-05-25   85  	seq_printf(m, "CachedSqHead:\t%u\n", ctx->cached_sq_head);
a4ad4f748ea962 Jens Axboe     2022-05-25   86  	seq_printf(m, "CqMask:\t0x%x\n", cq_mask);
a4ad4f748ea962 Jens Axboe     2022-05-25   87  	seq_printf(m, "CqHead:\t%u\n", cq_head);
a4ad4f748ea962 Jens Axboe     2022-05-25   88  	seq_printf(m, "CqTail:\t%u\n", cq_tail);
a4ad4f748ea962 Jens Axboe     2022-05-25   89  	seq_printf(m, "CachedCqTail:\t%u\n", ctx->cached_cq_tail);
3b8fdd1dc35e39 Jens Axboe     2022-09-11   90  	seq_printf(m, "SQEs:\t%u\n", sq_tail - sq_head);
a4ad4f748ea962 Jens Axboe     2022-05-25   91  	sq_entries = min(sq_tail - sq_head, ctx->sq_entries);
a4ad4f748ea962 Jens Axboe     2022-05-25   92  	for (i = 0; i < sq_entries; i++) {
a4ad4f748ea962 Jens Axboe     2022-05-25   93  		unsigned int entry = i + sq_head;
a4ad4f748ea962 Jens Axboe     2022-05-25   94  		struct io_uring_sqe *sqe;
3b8fdd1dc35e39 Jens Axboe     2022-09-11   95  		unsigned int sq_idx;
a4ad4f748ea962 Jens Axboe     2022-05-25   96  
32f5dea040ee6e Jens Axboe     2023-09-01   97  		if (ctx->flags & IORING_SETUP_NO_SQARRAY)
32f5dea040ee6e Jens Axboe     2023-09-01   98  			break;
3b8fdd1dc35e39 Jens Axboe     2022-09-11   99  		sq_idx = READ_ONCE(ctx->sq_array[entry & sq_mask]);
a4ad4f748ea962 Jens Axboe     2022-05-25  100  		if (sq_idx > sq_mask)
a4ad4f748ea962 Jens Axboe     2022-05-25  101  			continue;
00927931cb630b Pavel Begunkov 2022-10-11  102  		sqe = &ctx->sq_sqes[sq_idx << sq_shift];
3b8fdd1dc35e39 Jens Axboe     2022-09-11  103  		seq_printf(m, "%5u: opcode:%s, fd:%d, flags:%x, off:%llu, "
3b8fdd1dc35e39 Jens Axboe     2022-09-11  104  			      "addr:0x%llx, rw_flags:0x%x, buf_index:%d "
3b8fdd1dc35e39 Jens Axboe     2022-09-11  105  			      "user_data:%llu",
3b8fdd1dc35e39 Jens Axboe     2022-09-11  106  			   sq_idx, io_uring_get_opcode(sqe->opcode), sqe->fd,
3b8fdd1dc35e39 Jens Axboe     2022-09-11  107  			   sqe->flags, (unsigned long long) sqe->off,
3b8fdd1dc35e39 Jens Axboe     2022-09-11  108  			   (unsigned long long) sqe->addr, sqe->rw_flags,
3b8fdd1dc35e39 Jens Axboe     2022-09-11  109  			   sqe->buf_index, sqe->user_data);
3b8fdd1dc35e39 Jens Axboe     2022-09-11  110  		if (sq_shift) {
3b8fdd1dc35e39 Jens Axboe     2022-09-11  111  			u64 *sqeb = (void *) (sqe + 1);
3b8fdd1dc35e39 Jens Axboe     2022-09-11  112  			int size = sizeof(struct io_uring_sqe) / sizeof(u64);
3b8fdd1dc35e39 Jens Axboe     2022-09-11  113  			int j;
3b8fdd1dc35e39 Jens Axboe     2022-09-11  114  
3b8fdd1dc35e39 Jens Axboe     2022-09-11  115  			for (j = 0; j < size; j++) {
3b8fdd1dc35e39 Jens Axboe     2022-09-11  116  				seq_printf(m, ", e%d:0x%llx", j,
3b8fdd1dc35e39 Jens Axboe     2022-09-11  117  						(unsigned long long) *sqeb);
3b8fdd1dc35e39 Jens Axboe     2022-09-11  118  				sqeb++;
3b8fdd1dc35e39 Jens Axboe     2022-09-11  119  			}
3b8fdd1dc35e39 Jens Axboe     2022-09-11  120  		}
3b8fdd1dc35e39 Jens Axboe     2022-09-11  121  		seq_printf(m, "\n");
a4ad4f748ea962 Jens Axboe     2022-05-25  122  	}
a4ad4f748ea962 Jens Axboe     2022-05-25  123  	seq_printf(m, "CQEs:\t%u\n", cq_tail - cq_head);
a4ad4f748ea962 Jens Axboe     2022-05-25  124  	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
a4ad4f748ea962 Jens Axboe     2022-05-25  125  	for (i = 0; i < cq_entries; i++) {
a4ad4f748ea962 Jens Axboe     2022-05-25  126  		unsigned int entry = i + cq_head;
a4ad4f748ea962 Jens Axboe     2022-05-25  127  		struct io_uring_cqe *cqe = &r->cqes[(entry & cq_mask) << cq_shift];
a4ad4f748ea962 Jens Axboe     2022-05-25  128  
4f731705cc1f15 Jens Axboe     2022-09-11  129  		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x",
a4ad4f748ea962 Jens Axboe     2022-05-25  130  			   entry & cq_mask, cqe->user_data, cqe->res,
a4ad4f748ea962 Jens Axboe     2022-05-25  131  			   cqe->flags);
4f731705cc1f15 Jens Axboe     2022-09-11  132  		if (cq_shift)
4f731705cc1f15 Jens Axboe     2022-09-11  133  			seq_printf(m, ", extra1:%llu, extra2:%llu\n",
4f731705cc1f15 Jens Axboe     2022-09-11  134  					cqe->big_cqe[0], cqe->big_cqe[1]);
4f731705cc1f15 Jens Axboe     2022-09-11  135  		seq_printf(m, "\n");
a4ad4f748ea962 Jens Axboe     2022-05-25  136  	}
a4ad4f748ea962 Jens Axboe     2022-05-25  137  
5b1b61674371b7 Xiaobing Li    2023-11-15 @138  	if (ctx && (ctx->flags & IORING_SETUP_SQPOLL)) {
                                                    ^^^
Delete this check.

5b1b61674371b7 Xiaobing Li    2023-11-15  139  		struct io_sq_data *sq = ctx->sq_data;
5b1b61674371b7 Xiaobing Li    2023-11-15  140  
5b1b61674371b7 Xiaobing Li    2023-11-15 @141  		if (sq && sq->total_time != 0)
                                                            ^^
sq can be NULL?

5b1b61674371b7 Xiaobing Li    2023-11-15  142  			sq_busy = (int)(sq->work_time * 100 / sq->total_time);
5b1b61674371b7 Xiaobing Li    2023-11-15  143  
5b1b61674371b7 Xiaobing Li    2023-11-15 @144  		sq_pid = sq->task_pid;
                                                                 ^^^^
Unchecked dereference.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


