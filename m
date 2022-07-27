Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8D05832BB
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 21:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiG0TEW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 15:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiG0TD6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 15:03:58 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090122C119
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 11:24:30 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id r70so14160619iod.10
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hHmGHAevB98EfdGb6fEdaWeyTHQHrA+JqQDoaDH//wY=;
        b=N90okzsD78l1xHx1fGToSSHAM9f1jKIPx1x3grX4vBSoO1JBIZy3K34WOT5zZ3TKDt
         AdJMcWDkMoCtCWm6AggPcjkWnXHaDrtPtnu3zgp/Xc33snDecPZPOfTNHcf8I5mmIG9Q
         GjtLjhfAy/iyoltYNOrElX2hJf+SUFKAfoK9I7jkQpobXYj907c/jQbk4HUXzhfQUl5g
         BBxh5cbdo5hnB4W/1WaLUK0WIXkKvqcc18OKFcTKolzRdzBDkRLyaVAdc2FkMtoNQvY3
         P2P/f/Y1KRUMTYAf1vf+DbiupQj1LLvKnXaACnefind9bmDIWOSu6oCgyLVul5ujMhbf
         kCeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hHmGHAevB98EfdGb6fEdaWeyTHQHrA+JqQDoaDH//wY=;
        b=QJYGwoF3EetO3blL1wj1C7av3miD6RhTTqA8VCdE83PQfFKV5280c4WhnnKpS61gH/
         RBueYR7RUV/E7l55J6fAyXtWkFS0Okhzf59IXb8o7f8baj/DRhLTBq+h7TSMNuRh++qQ
         LYzdFYlIGqkZS7CIq+PqLmJ9elwKYwDvp3WAJhziNO84WSB5uYvcS87ffsHiSG5J2yU1
         k7vhPvsvaLwfd3TUj5n1IpT5YOrxv/BRe7z4q5tgPbXr4xpci1SuTyTscCOCBiKw9Mh3
         Bw0I1ThLqWUHHB+Y+oSpQh3U31+pKtaitklJAr0RtDIcrSOmDLS3LMf6mdPaAe95MJcA
         Gs+g==
X-Gm-Message-State: AJIora/VyLTxP6j7lveyG9t2vswi62Q/jCAlTROWIsnd24nMRx3NPiiT
        bPIElsWGRisuiGUG9KNiTYOX/2Z6h4UwGw==
X-Google-Smtp-Source: AGRyM1t6b2bTJI2xeT4biEiBrFXU/bB+yWvRqeY84UmawXhrGpxlEj2f3Ik3nZj7DRJ/nY+/HLUlFQ==
X-Received: by 2002:a05:6638:1b09:b0:33f:6d9e:89d0 with SMTP id cb9-20020a0566381b0900b0033f6d9e89d0mr9417285jab.113.1658946269256;
        Wed, 27 Jul 2022 11:24:29 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n24-20020a056638111800b0034195de93b3sm8133861jal.51.2022.07.27.11.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 11:24:28 -0700 (PDT)
Message-ID: <b37438e3-4dec-2285-cf5f-896c3a7ab6ef@kernel.dk>
Date:   Wed, 27 Jul 2022 12:24:27 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH liburing v2 3/5] nvme: add nvme opcodes, structures and
 helper functions
Content-Language: en-US
To:     Ankit Kumar <ankit.kumar@samsung.com>
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com
References: <20220726105230.12025-1-ankit.kumar@samsung.com>
 <CGME20220726105815epcas5p2e19ff2fe748cfeb69517124370de3b7f@epcas5p2.samsung.com>
 <20220726105230.12025-4-ankit.kumar@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220726105230.12025-4-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/26/22 4:52 AM, Ankit Kumar wrote:
> Add bare minimum structures and helper functions required for
> io_uring passthrough commands. This will enable the follow up
> patch to add tests for nvme-ns generic character device.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>  test/nvme.h | 168 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 168 insertions(+)
>  create mode 100644 test/nvme.h
> 
> diff --git a/test/nvme.h b/test/nvme.h
> new file mode 100644
> index 0000000..866a7e6
> --- /dev/null
> +++ b/test/nvme.h
> @@ -0,0 +1,168 @@
> +/* SPDX-License-Identifier: MIT */
> +/*
> + * Description: Helpers for NVMe uring passthrough commands
> + */
> +#ifndef LIBURING_NVME_H
> +#define LIBURING_NVME_H
> +
> +#ifdef __cplusplus
> +extern "C" {
> +#endif
> +
> +#include <sys/ioctl.h>
> +#include <linux/nvme_ioctl.h>
> +
> +/*
> + * If the uapi headers installed on the system lacks nvme uring command
> + * support, use the local version to prevent compilation issues.
> + */
> +#ifndef CONFIG_HAVE_NVME_URING
> +struct nvme_uring_cmd {
> +	__u8	opcode;
> +	__u8	flags;
> +	__u16	rsvd1;
> +	__u32	nsid;
> +	__u32	cdw2;
> +	__u32	cdw3;
> +	__u64	metadata;
> +	__u64	addr;
> +	__u32	metadata_len;
> +	__u32	data_len;
> +	__u32	cdw10;
> +	__u32	cdw11;
> +	__u32	cdw12;
> +	__u32	cdw13;
> +	__u32	cdw14;
> +	__u32	cdw15;
> +	__u32	timeout_ms;
> +	__u32   rsvd2;
> +};
> +
> +#define NVME_URING_CMD_IO	_IOWR('N', 0x80, struct nvme_uring_cmd)
> +#define NVME_URING_CMD_IO_VEC	_IOWR('N', 0x81, struct nvme_uring_cmd)
> +#endif /* CONFIG_HAVE_NVME_URING */
> +
> +#define NVME_DEFAULT_IOCTL_TIMEOUT 0
> +#define NVME_IDENTIFY_DATA_SIZE 4096
> +#define NVME_IDENTIFY_CSI_SHIFT 24
> +#define NVME_IDENTIFY_CNS_NS 0
> +#define NVME_CSI_NVM 0
> +
> +enum nvme_admin_opcode {
> +	nvme_admin_identify		= 0x06,
> +};
> +
> +enum nvme_io_opcode {
> +	nvme_cmd_write			= 0x01,
> +	nvme_cmd_read			= 0x02,
> +};
> +
> +int nsid;
> +__u32 lba_shift;
> +
> +struct nvme_lbaf {
> +	__le16			ms;
> +	__u8			ds;
> +	__u8			rp;
> +};
> +
> +struct nvme_id_ns {
> +	__le64			nsze;
> +	__le64			ncap;
> +	__le64			nuse;
> +	__u8			nsfeat;
> +	__u8			nlbaf;
> +	__u8			flbas;
> +	__u8			mc;
> +	__u8			dpc;
> +	__u8			dps;
> +	__u8			nmic;
> +	__u8			rescap;
> +	__u8			fpi;
> +	__u8			dlfeat;
> +	__le16			nawun;
> +	__le16			nawupf;
> +	__le16			nacwu;
> +	__le16			nabsn;
> +	__le16			nabo;
> +	__le16			nabspf;
> +	__le16			noiob;
> +	__u8			nvmcap[16];
> +	__le16			npwg;
> +	__le16			npwa;
> +	__le16			npdg;
> +	__le16			npda;
> +	__le16			nows;
> +	__le16			mssrl;
> +	__le32			mcl;
> +	__u8			msrc;
> +	__u8			rsvd81[11];
> +	__le32			anagrpid;
> +	__u8			rsvd96[3];
> +	__u8			nsattr;
> +	__le16			nvmsetid;
> +	__le16			endgid;
> +	__u8			nguid[16];
> +	__u8			eui64[8];
> +	struct nvme_lbaf	lbaf[16];
> +	__u8			rsvd192[192];
> +	__u8			vs[3712];
> +};
> +
> +static inline int ilog2(uint32_t i)
> +{
> +	int log = -1;
> +
> +	while (i) {
> +		i >>= 1;
> +		log++;
> +	}
> +	return log;
> +}
> +
> +int fio_nvme_get_info(const char *file)
> +{
> +	struct nvme_id_ns ns;
> +	int fd, err;
> +	__u32 lba_size;
> +
> +	fd = open(file, O_RDONLY);
> +	if (fd < 0)
> +		return -errno;
> +
> +	nsid = ioctl(fd, NVME_IOCTL_ID);
> +	if (nsid < 0) {
> +		fprintf(stderr, "failed to fetch namespace-id\n");
> +		close(fd);
> +		return -errno;
> +	}
> +
> +	struct nvme_passthru_cmd cmd = {
> +		.opcode         = nvme_admin_identify,
> +		.nsid           = nsid,
> +		.addr           = (__u64)(uintptr_t)&ns,
> +		.data_len       = NVME_IDENTIFY_DATA_SIZE,
> +		.cdw10          = NVME_IDENTIFY_CNS_NS,
> +		.cdw11          = NVME_CSI_NVM << NVME_IDENTIFY_CSI_SHIFT,
> +		.timeout_ms     = NVME_DEFAULT_IOCTL_TIMEOUT,
> +	};
> +
> +	err = ioctl(fd, NVME_IOCTL_ADMIN_CMD, &cmd);
> +	if (err) {
> +		fprintf(stderr, "failed to fetch identify namespace\n");
> +		close(fd);
> +		return err;
> +	}
> +
> +	lba_size = 1 << ns.lbaf[(ns.flbas & 0x0f)].ds;
> +	lba_shift = ilog2(lba_size);
> +
> +	close(fd);
> +	return 0;
> +}

Too much copy pasting I think? Probably should not prefix this one with
fio?

-- 
Jens Axboe

