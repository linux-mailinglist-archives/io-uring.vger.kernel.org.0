Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB93930602C
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 16:49:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhA0Ptg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 10:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236396AbhA0Prg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 10:47:36 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114B8C061574;
        Wed, 27 Jan 2021 07:46:30 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id by1so3342132ejc.0;
        Wed, 27 Jan 2021 07:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R6ZtaEsn6Sf5kkQW+eu8pA6vL+665kl4n5FmAL3X834=;
        b=qc1n+BUSQE/jRJWgJTsugV3ZKoeDqi6vXjTgRGQTTvxmixuE4nNxGdSng2g/nOwJK6
         x6lrwbQEntwyqkYr4GZHkdpguGIXT8gF+b33DgJbHvbgLen+ax4hHCatHjS101kMG7yE
         b85Eq7FQonWY/DTLYf7mHYpkutnS/1SICpeDddCllvBrrKgYnQjMQXodz2KLTc3MJpfM
         SOJkb9Xs0GB5TM6Lm23shPDLZIK5A/xMN10E8lkIz4dc1NFTRZqxp3o7DyGm5rDL+GKP
         phArhTh/55ZzXeeZx9DCo7nRsHJ7xiwPw/q5arDYddVjv2NDQXW0iG1LPJyu+hFiNVwR
         d/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=R6ZtaEsn6Sf5kkQW+eu8pA6vL+665kl4n5FmAL3X834=;
        b=smuY9qgXAciAZq14nfAsWG900Blmv6afAw6Gj802qwRyD5XRzxYeonaTGPVL2/oQBZ
         //T3BW/QamZA2k2juce7Slt9X+OejNGY9GlYq9phcwbraYiHv65QVXZnIFbpE/Mk52Q6
         rfUiswhlEVEG3uK29u2Uf6cEAfA0xduIMzfbqvtrUxfkdKf8Wnk1YUZgTTGGUkhTGlHZ
         f6SW9AHYtEKQCgVy2gXuh1hSEnVrr45pKlryZYgq/jZCEC+h158GZygJMwZ2nO211Hvt
         D1JTwRzpVhXTKShfAQsd7TszCrTGkJH6l4twFxVMbBSWs9Vrq0VaFhY+nkTrJRE5hdU2
         btdg==
X-Gm-Message-State: AOAM532c0xvV+IDQCAtK3+5d9WcSS2MHm+PJi3YIXWWwDiB9DmMvYuLu
        4r3n4AOjvoS1xRq/l2YgQrI=
X-Google-Smtp-Source: ABdhPJz7cdpvTQKpJpMQS9aa2CgqNKsN+IY4UfJZS5pk04mER3fbg7VqI2ouR0mJ/O949IBOxqI4qQ==
X-Received: by 2002:a17:906:90c3:: with SMTP id v3mr7493267ejw.461.1611762388705;
        Wed, 27 Jan 2021 07:46:28 -0800 (PST)
Received: from [192.168.8.160] ([148.252.129.161])
        by smtp.gmail.com with ESMTPSA id ke7sm1019020ejc.7.2021.01.27.07.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jan 2021 07:46:28 -0800 (PST)
Subject: Re: [RFC PATCH 0/4] Asynchronous passthrough ioctl
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, hch@lst.de, sagi@grimberg.me
Cc:     linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com
References: <CGME20210127150134epcas5p251fc1de3ff3581dd4c68b3fbe0b9dd91@epcas5p2.samsung.com>
 <20210127150029.13766-1-joshi.k@samsung.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <489691ce-3b1e-30ce-9f72-d32389e33901@gmail.com>
Date:   Wed, 27 Jan 2021 15:42:46 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20210127150029.13766-1-joshi.k@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 27/01/2021 15:00, Kanchan Joshi wrote:
> This RFC patchset adds asynchronous ioctl capability for NVMe devices.
> Purpose of RFC is to get the feedback and optimize the path.
> 
> At the uppermost io-uring layer, a new opcode IORING_OP_IOCTL_PT is
> presented to user-space applications. Like regular-ioctl, it takes
> ioctl opcode and an optional argument (ioctl-specific input/output
> parameter). Unlike regular-ioctl, it is made to skip the block-layer
> and reach directly to the underlying driver (nvme in the case of this
> patchset). This path between io-uring and nvme is via a newly
> introduced block-device operation "async_ioctl". This operation
> expects io-uring to supply a callback function which can be used to
> report completion at later stage.
> 
> For a regular ioctl, NVMe driver submits the command to the device and
> the submitter (task) is made to wait until completion arrives. For
> async-ioctl, completion is decoupled from submission. Submitter goes
> back to its business without waiting for nvme-completion. When
> nvme-completion arrives, it informs io-uring via the registered
> completion-handler. But some ioctls may require updating certain
> ioctl-specific fields which can be accessed only in context of the
> submitter task. For that reason, NVMe driver uses task-work infra for
> that ioctl-specific update. Since task-work is not exported, it cannot
> be referenced when nvme is compiled as a module. Therefore, one of the
> patch exports task-work API.
> 
> Here goes example of usage (pseudo-code).
> Actual nvme-cli source, modified to issue all ioctls via this opcode
> is present at-
> https://github.com/joshkan/nvme-cli/commit/a008a733f24ab5593e7874cfbc69ee04e88068c5

see https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops

Looks like good time to bring that branch/discussion back

> 
> With regular ioctl-
> int nvme_submit_passthru(int fd, unsigned long ioctl_cmd,
>                          struct nvme_passthru_cmd *cmd)
> {
> 	return ioctl(fd, ioctl_cmd, cmd);
> }
> 
> With uring passthru ioctl-
> int nvme_submit_passthru(int fd, unsigned long ioctl_cmd,
>                          struct nvme_passthru_cmd *cmd)
> {
> 	return uring_ioctl(fd, ioctl_cmd, cmd);
> }
> int uring_ioctl(int fd, unsinged long cmd, u64 arg)
> {
> 	sqe = io_uring_get_sqe(ring);
> 
> 	/* prepare sqe */
> 	sqe->fd = fd;
> 	sqe->opcode = IORING_OP_IOCTL_PT;
> 	sqe->ioctl_cmd = cmd;
> 	sqe->ioctl_arg = arg;
> 
> 	/* submit sqe */
> 	io_uring_submit(ring);
> 
> 	/* reap completion and obtain result */
> 	io_uring_wait_cqe(ring, &cqe);
> 	printf("ioctl result =%d\n", cqe->res)
> }
> 
> Kanchan Joshi (4):
>   block: introduce async ioctl operation
>   kernel: export task_work_add
>   nvme: add async ioctl support
>   io_uring: add async passthrough ioctl support
> 
>  drivers/nvme/host/core.c      | 347 +++++++++++++++++++++++++++-------
>  fs/io_uring.c                 |  77 ++++++++
>  include/linux/blkdev.h        |  12 ++
>  include/uapi/linux/io_uring.h |   7 +-
>  kernel/task_work.c            |   2 +-
>  5 files changed, 376 insertions(+), 69 deletions(-)
> 

-- 
Pavel Begunkov
