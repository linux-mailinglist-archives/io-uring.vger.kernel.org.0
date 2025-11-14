Return-Path: <io-uring+bounces-10635-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 566D2C5D489
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 14:15:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8535235DB92
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 13:09:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEA9E245012;
	Fri, 14 Nov 2025 13:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SIrUVwtL"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABE27990C
	for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 13:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763125760; cv=none; b=P2iPw7DMEe+7GcW2vCTPc2WsLFVyjGUDJ62fodN6xELRll4eGFzfgZajHYxg81GmSZNzC2FaJv2ZvNwvT6iPCUpvBiwpgYvPM+OCwjLuUcfHXmQLxwFUUrCIHP8fkH6hM1KtfSzffjTVr6i+95QsHpwz9LdZ5PdOtzl6knx1hqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763125760; c=relaxed/simple;
	bh=vtfSQuOSZCSP/HysdkmZSuiURW9C5FdabXdwoe42lnE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jkHtruPRnquUUMHiZxIoWociRm1Nagq37qp4SyHSqZM/hiIsf3ieIcndH5m4imGueSwtd3RgsHUt6a7V1giDFb8Tjoaf+UmnEfDt6054VwQmbTv6C79gfMpccGyc1CX/n/ZfySqx+pdU4ZaufPSWAf2XT1lz0Tzk4JxjL4e6szk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SIrUVwtL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763125757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pH2adpZ1ttv0IwuN13dvpzSOC4f84gcUvWc/uXacs3w=;
	b=SIrUVwtLNT0Cin7m9aERp5lCMjdcUfsOfLZ4VvsnJTQMD8w0ETZJUzLpq8tXssDuBc39JM
	PvyKU6bSOrq4LSWDZHXN9T3Bfjs39PmrWK0LGET4iZPJglMkz5IakPPZZh7Qk06wB7qb5I
	HOqLSPI7HEfn0C9FesAKYQM4ypjo4Xc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-593-rLVIhnt9NBOeuiT2msJO_w-1; Fri,
 14 Nov 2025 08:09:14 -0500
X-MC-Unique: rLVIhnt9NBOeuiT2msJO_w-1
X-Mimecast-MFC-AGG-ID: rLVIhnt9NBOeuiT2msJO_w_1763125753
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9961019560B0;
	Fri, 14 Nov 2025 13:09:12 +0000 (UTC)
Received: from fedora (unknown [10.72.116.81])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B7126180049F;
	Fri, 14 Nov 2025 13:09:03 +0000 (UTC)
Date: Fri, 14 Nov 2025 21:08:52 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>, bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH v3 10/10] selftests/io_uring: add bpf io_uring selftests
Message-ID: <aRcp5Gi41i-g64ov@fedora>
References: <cover.1763031077.git.asml.silence@gmail.com>
 <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6143e4393c645c539fc34dc37eeb6d682ad073b9.1763031077.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Nov 13, 2025 at 11:59:47AM +0000, Pavel Begunkov wrote:
> Add a io_uring bpf selftest/example. runner.c sets up a ring and BPF and
> calls io_uring_enter syscall to run the BPF program. All the execution
> logic is in basic.bpf.c, which creates a request, waits for its
> completion and repeats it N=10 times, after which it terminates. The
> makefile is borrowed from sched_ext.
> 
> Note, it doesn't need to be all in BPF and can be intermingled with
> userspace code. This needs a separate example.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  tools/testing/selftests/Makefile             |   3 +-
>  tools/testing/selftests/io_uring/Makefile    | 164 +++++++++++++++++++
>  tools/testing/selftests/io_uring/basic.bpf.c |  81 +++++++++
>  tools/testing/selftests/io_uring/common.h    |   2 +
>  tools/testing/selftests/io_uring/runner.c    |  80 +++++++++
>  tools/testing/selftests/io_uring/types.bpf.h | 136 +++++++++++++++
>  6 files changed, 465 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/io_uring/Makefile
>  create mode 100644 tools/testing/selftests/io_uring/basic.bpf.c
>  create mode 100644 tools/testing/selftests/io_uring/common.h
>  create mode 100644 tools/testing/selftests/io_uring/runner.c
>  create mode 100644 tools/testing/selftests/io_uring/types.bpf.h
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index c46ebdb9b8ef..31dd369a7154 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -129,6 +129,7 @@ TARGETS += vfio
>  TARGETS += x86
>  TARGETS += x86/bugs
>  TARGETS += zram
> +TARGETS += io_uring
>  #Please keep the TARGETS list alphabetically sorted
>  # Run "make quicktest=1 run_tests" or
>  # "make quicktest=1 kselftest" from top level Makefile
> @@ -146,7 +147,7 @@ endif
>  # User can optionally provide a TARGETS skiplist. By default we skip
>  # targets using BPF since it has cutting edge build time dependencies
>  # which require more effort to install.
> -SKIP_TARGETS ?= bpf sched_ext
> +SKIP_TARGETS ?= bpf sched_ext io_uring
>  ifneq ($(SKIP_TARGETS),)
>  	TMP := $(filter-out $(SKIP_TARGETS), $(TARGETS))
>  	override TARGETS := $(TMP)
> diff --git a/tools/testing/selftests/io_uring/Makefile b/tools/testing/selftests/io_uring/Makefile
> new file mode 100644
> index 000000000000..7dfba422e5a6
> --- /dev/null
> +++ b/tools/testing/selftests/io_uring/Makefile
> @@ -0,0 +1,164 @@
> +# SPDX-License-Identifier: GPL-2.0
> +include ../../../build/Build.include
> +include ../../../scripts/Makefile.arch
> +include ../../../scripts/Makefile.include
> +
> +TEST_GEN_PROGS := runner
> +
> +# override lib.mk's default rules
> +OVERRIDE_TARGETS := 1
> +include ../lib.mk
> +
> +CURDIR := $(abspath .)
> +REPOROOT := $(abspath ../../../..)
> +TOOLSDIR := $(REPOROOT)/tools
> +LIBDIR := $(TOOLSDIR)/lib
> +BPFDIR := $(LIBDIR)/bpf
> +TOOLSINCDIR := $(TOOLSDIR)/include
> +BPFTOOLDIR := $(TOOLSDIR)/bpf/bpftool
> +APIDIR := $(TOOLSINCDIR)/uapi
> +GENDIR := $(REPOROOT)/include/generated
> +GENHDR := $(GENDIR)/autoconf.h
> +
> +OUTPUT_DIR := $(OUTPUT)/build
> +OBJ_DIR := $(OUTPUT_DIR)/obj
> +INCLUDE_DIR := $(OUTPUT_DIR)/include
> +BPFOBJ_DIR := $(OBJ_DIR)/libbpf
> +IOUOBJ_DIR := $(OBJ_DIR)/io_uring
> +LIBBPF_OUTPUT := $(OBJ_DIR)/libbpf/libbpf.a
> +BPFOBJ := $(BPFOBJ_DIR)/libbpf.a
> +
> +DEFAULT_BPFTOOL := $(OUTPUT_DIR)/host/sbin/bpftool
> +HOST_OBJ_DIR := $(OBJ_DIR)/host/bpftool
> +HOST_LIBBPF_OUTPUT := $(OBJ_DIR)/host/libbpf/
> +HOST_LIBBPF_DESTDIR := $(OUTPUT_DIR)/host/
> +HOST_DESTDIR := $(OUTPUT_DIR)/host/
> +
> +VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)					\
> +		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)		\
> +		     ../../../../vmlinux					\
> +		     /sys/kernel/btf/vmlinux					\
> +		     /boot/vmlinux-$(shell uname -r)
> +VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
> +ifeq ($(VMLINUX_BTF),)
> +$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
> +endif
> +
> +BPFTOOL ?= $(DEFAULT_BPFTOOL)
> +
> +ifneq ($(wildcard $(GENHDR)),)
> +  GENFLAGS := -DHAVE_GENHDR
> +endif
> +
> +CFLAGS += -g -O2 -rdynamic -pthread -Wall -Werror $(GENFLAGS)			\
> +	  -I$(INCLUDE_DIR) -I$(GENDIR) -I$(LIBDIR)				\
> +	  -I$(TOOLSINCDIR) -I$(APIDIR) -I$(CURDIR)/include
> +
> +# Silence some warnings when compiled with clang
> +ifneq ($(LLVM),)
> +CFLAGS += -Wno-unused-command-line-argument
> +endif
> +
> +LDFLAGS = -lelf -lz -lpthread -lzstd
> +
> +IS_LITTLE_ENDIAN = $(shell $(CC) -dM -E - </dev/null |				\
> +			grep 'define __BYTE_ORDER__ __ORDER_LITTLE_ENDIAN__')
> +
> +# Get Clang's default includes on this system, as opposed to those seen by
> +# '-target bpf'. This fixes "missing" files on some architectures/distros,
> +# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> +#
> +# Use '-idirafter': Don't interfere with include mechanics except where the
> +# build would have failed anyways.
> +define get_sys_includes
> +$(shell $(1) $(2) -v -E - </dev/null 2>&1 \
> +	| sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
> +$(shell $(1) $(2) -dM -E - </dev/null | grep '__riscv_xlen ' | awk '{printf("-D__riscv_xlen=%d -D__BITS_PER_LONG=%d", $$3, $$3)}')
> +endef
> +
> +ifneq ($(CROSS_COMPILE),)
> +CLANG_TARGET_ARCH = --target=$(notdir $(CROSS_COMPILE:%-=%))
> +endif
> +
> +CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG),$(CLANG_TARGET_ARCH))
> +
> +BPF_CFLAGS = -g -D__TARGET_ARCH_$(SRCARCH)					\
> +	     $(if $(IS_LITTLE_ENDIAN),-mlittle-endian,-mbig-endian)		\
> +	     -I$(CURDIR)/include -I$(CURDIR)/include/bpf-compat			\
> +	     -I$(INCLUDE_DIR) -I$(APIDIR) 	\
> +	     -I$(REPOROOT)/include						\
> +	     $(CLANG_SYS_INCLUDES) 						\
> +	     -Wall -Wno-compare-distinct-pointer-types				\
> +	     -Wno-incompatible-function-pointer-types				\
> +	     -O2 -mcpu=v3
> +
> +# sort removes libbpf duplicates when not cross-building
> +MAKE_DIRS := $(sort $(OBJ_DIR)/libbpf $(OBJ_DIR)/libbpf				\
> +	       $(OBJ_DIR)/bpftool $(OBJ_DIR)/resolve_btfids			\
> +	       $(HOST_OBJ_DIR) $(INCLUDE_DIR) $(IOUOBJ_DIR))
> +
> +$(MAKE_DIRS):
> +	$(call msg,MKDIR,,$@)
> +	$(Q)mkdir -p $@
> +
> +$(BPFOBJ): $(wildcard $(BPFDIR)/*.[ch] $(BPFDIR)/Makefile)			\
> +	   $(APIDIR)/linux/bpf.h						\
> +	   | $(OBJ_DIR)/libbpf
> +	$(Q)$(MAKE) $(submake_extras) -C $(BPFDIR) OUTPUT=$(OBJ_DIR)/libbpf/	\
> +		    ARCH=$(ARCH) CC="$(CC)" CROSS_COMPILE=$(CROSS_COMPILE)	\
> +		    EXTRA_CFLAGS='-g -O0 -fPIC'					\
> +		    DESTDIR=$(OUTPUT_DIR) prefix= all install_headers
> +
> +$(DEFAULT_BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)	\
> +		    $(LIBBPF_OUTPUT) | $(HOST_OBJ_DIR)
> +	$(Q)$(MAKE) $(submake_extras)  -C $(BPFTOOLDIR)				\
> +		    ARCH= CROSS_COMPILE= CC=$(HOSTCC) LD=$(HOSTLD)		\
> +		    EXTRA_CFLAGS='-g -O0'					\
> +		    OUTPUT=$(HOST_OBJ_DIR)/					\
> +		    LIBBPF_OUTPUT=$(HOST_LIBBPF_OUTPUT)				\
> +		    LIBBPF_DESTDIR=$(HOST_LIBBPF_DESTDIR)			\
> +		    prefix= DESTDIR=$(HOST_DESTDIR) install-bin
> +
> +$(INCLUDE_DIR)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL) | $(INCLUDE_DIR)
> +ifeq ($(VMLINUX_H),)
> +	$(call msg,GEN,,$@)
> +	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
> +else
> +	$(call msg,CP,,$@)
> +	$(Q)cp "$(VMLINUX_H)" $@
> +endif
> +
> +$(IOUOBJ_DIR)/%.bpf.o: %.bpf.c $(INCLUDE_DIR)/vmlinux.h	| $(BPFOBJ) $(IOUOBJ_DIR)
> +	$(call msg,CLNG-BPF,,$(notdir $@))
> +	$(Q)$(CLANG) $(BPF_CFLAGS) -target bpf -c $< -o $@
> +
> +$(INCLUDE_DIR)/%.bpf.skel.h: $(IOUOBJ_DIR)/%.bpf.o $(INCLUDE_DIR)/vmlinux.h $(BPFTOOL) | $(INCLUDE_DIR)
> +	$(eval sched=$(notdir $@))
> +	$(call msg,GEN-SKEL,,$(sched))
> +	$(Q)$(BPFTOOL) gen object $(<:.o=.linked1.o) $<
> +	$(Q)$(BPFTOOL) gen object $(<:.o=.linked2.o) $(<:.o=.linked1.o)
> +	$(Q)$(BPFTOOL) gen object $(<:.o=.linked3.o) $(<:.o=.linked2.o)
> +	$(Q)diff $(<:.o=.linked2.o) $(<:.o=.linked3.o)
> +	$(Q)$(BPFTOOL) gen skeleton $(<:.o=.linked3.o) name $(subst .bpf.skel.h,,$(sched)) > $@
> +	$(Q)$(BPFTOOL) gen subskeleton $(<:.o=.linked3.o) name $(subst .bpf.skel.h,,$(sched)) > $(@:.skel.h=.subskel.h)
> +
> +override define CLEAN
> +	rm -rf $(OUTPUT_DIR)
> +	rm -f $(TEST_GEN_PROGS)
> +endef
> +
> +all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubst %.c,%.skel.h,$(prog)))
> +
> +$(IOUOBJ_DIR)/runner.o: runner.c $(all_test_bpfprogs) | $(IOUOBJ_DIR) $(BPFOBJ)
> +	$(CC) $(CFLAGS) -c $< -o $@
> +
> +$(OUTPUT)/runner: $(IOUOBJ_DIR)/runner.o $(BPFOBJ)
> +	@echo "$(testcase-targets)"
> +	echo 111
> +	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
> +
> +.DEFAULT_GOAL := all
> +
> +.DELETE_ON_ERROR:
> +
> +.SECONDARY:
> diff --git a/tools/testing/selftests/io_uring/basic.bpf.c b/tools/testing/selftests/io_uring/basic.bpf.c
> new file mode 100644
> index 000000000000..c7954146ae4d
> --- /dev/null
> +++ b/tools/testing/selftests/io_uring/basic.bpf.c
> @@ -0,0 +1,81 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#include <linux/types.h>
> +#include <linux/stddef.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +#include "types.bpf.h"
> +#include "common.h"
> +
> +extern int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr) __ksym;
> +extern __u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id,
> +				     const __u64 rdwr_buf_size) __ksym;
> +
> +static inline void io_bpf_wait_nr(struct io_ring_ctx *ring,
> +				  struct iou_loop_state *ls, int nr)
> +{
> +	ls->cq_tail = ring->rings->cq.head + nr;
> +}
> +
> +enum {
> +	RINGS_REGION_ID		= 0,
> +	SQ_REGION_ID		= 1,
> +};
> +
> +char LICENSE[] SEC("license") = "Dual BSD/GPL";
> +int reqs_to_run;
> +
> +SEC("struct_ops.s/link_loop")
> +int BPF_PROG(link_loop, struct io_ring_ctx *ring, struct iou_loop_state *ls)
> +{
> +	struct ring_hdr *sq_hdr, *cq_hdr;
> +	struct io_uring_cqe *cqe, *cqes;
> +	struct io_uring_sqe *sqes, *sqe;
> +	void *rings;
> +	int ret;
> +
> +	sqes = (void *)bpf_io_uring_get_region(ring, SQ_REGION_ID,
> +				SQ_ENTRIES * sizeof(struct io_uring_sqe));
> +	rings = (void *)bpf_io_uring_get_region(ring, RINGS_REGION_ID,
> +				64 + CQ_ENTRIES * sizeof(struct io_uring_cqe));
> +	if (!rings || !sqes) {
> +		bpf_printk("error: can't get regions");
> +		return IOU_LOOP_STOP;
> +	}
> +
> +	sq_hdr = rings;
> +	cq_hdr = sq_hdr + 1;
> +	cqes = rings + 64;
> +
> +	if (cq_hdr->tail != cq_hdr->head) {
> +		unsigned cq_mask = CQ_ENTRIES - 1;
> +
> +		cqe = &cqes[cq_hdr->head++ & cq_mask];
> +		bpf_printk("found cqe: data %lu res %i",
> +			   (unsigned long)cqe->user_data, (int)cqe->res);
> +
> +		int left = --reqs_to_run;
> +		if (left <= 0) {
> +			bpf_printk("finished");
> +			return IOU_LOOP_STOP;
> +		}
> +	}
> +
> +	bpf_printk("queue nop request, data %lu\n", (unsigned long)reqs_to_run);
> +	sqe = &sqes[sq_hdr->tail & (SQ_ENTRIES - 1)];
> +	sqe->user_data = reqs_to_run;
> +	sq_hdr->tail++;

Looks this way turns io_uring_enter() into pthread-unsafe, does it need to
be documented?


Thanks, 
Ming


