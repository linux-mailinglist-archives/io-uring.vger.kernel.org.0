Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D15251C0F8
	for <lists+io-uring@lfdr.de>; Thu,  5 May 2022 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244117AbiEENmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 May 2022 09:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiEENmN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 May 2022 09:42:13 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4391C902
        for <io-uring@vger.kernel.org>; Thu,  5 May 2022 06:38:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so5670168pjb.1
        for <io-uring@vger.kernel.org>; Thu, 05 May 2022 06:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iNCWFKzm430XXHX9xLlEge2B08P/sszyAC5WbnoeHJU=;
        b=KXTrYJvc/6dhACmv+XHv1BYrkg4M2puEeZahBJUNUn/xXrFCKWsTns9UST1o3e3b76
         hiLDUeZM5TjU8YJLGd/YIPnXikXALp3bG9IVa9tG0EzBNzbhpbccLGvAlO61y4FfuBLz
         tO0Ct50bJSHST5G90CvXZC4kQVukNlej5dZPE9kX8Ob2vnPdATfKaGchPS/L4YQ35bI4
         elMHSlLJZu8o7uL/Bb8Py+TXSuUIoyjWZvfG/URE0eNaOpHyfjkL3DE9wl8IKLpV4ebJ
         tjD/m/V73CBSFNVGDVIvcsUhTlqRlPMmefwODFXQEo+e9pChskU8ECpp8JzIkI1p7CEs
         I/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iNCWFKzm430XXHX9xLlEge2B08P/sszyAC5WbnoeHJU=;
        b=BWc+LTzinpJD2rwDI63xDUvstTu3o6zG1E1uaafstodC9rNiwqd+I/IhJMUvQNA+9+
         A5/IT8D+fmlS+VwcUduWJfOy8XKb7E6F9i7P8DoMpvZOOQDRY6WPmee4AgJUcTUiXy1g
         cUxID3FfBHOqQa5Z9CmvJ365KoAy77IoqHTfAgKT7aGcOI/ZhHNfyEbB/drBwCBKSTeh
         01Kl6EkT3kn0AMwyWHp/4FnrpdTs8MDyJxE9DPlQ3j9yyCHM1twCZUYOFpjiUXBmGyci
         Tpvlmi9siYU//YVfPUPUR8Iphv9wZxUjDYmojdSwkd7mGmlWYACWMJzOiGXIOROUjKxA
         4yZw==
X-Gm-Message-State: AOAM533ZnHnGCEZJ0AFxU8oSdoc9/DarqBXcGi/ZQX6/e5dScE9M2RqL
        7T5c4fA8sMJ7tTiUE0fPxQePGA==
X-Google-Smtp-Source: ABdhPJwjFQeh1yi+86NAb1iw1sGLkFH+B5HRlCYzxg07JVOyiJ2DwgDCqJQuGFEYjIelOEkJCmspTA==
X-Received: by 2002:a17:90a:5b09:b0:1cd:b3d3:a3f3 with SMTP id o9-20020a17090a5b0900b001cdb3d3a3f3mr6328234pji.9.1651757913585;
        Thu, 05 May 2022 06:38:33 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id a10-20020a170902b58a00b0015e9f45c1f4sm1511480pls.186.2022.05.05.06.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 06:38:33 -0700 (PDT)
Message-ID: <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
Date:   Thu, 5 May 2022 07:38:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Content-Language: en-US
To:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, ming.lei@redhat.com, mcgrof@kernel.org,
        shr@fb.com, joshiiitr@gmail.com, anuj20.g@samsung.com,
        gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
 <20220505060616.803816-5-joshi.k@samsung.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220505060616.803816-5-joshi.k@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/22 12:06 AM, Kanchan Joshi wrote:
> +static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
> +		struct io_uring_cmd *ioucmd, unsigned int issue_flags)
> +{
> +	struct nvme_uring_cmd *cmd =
> +		(struct nvme_uring_cmd *)ioucmd->cmd;
> +	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
> +	struct nvme_command c;
> +	struct request *req;
> +	unsigned int rq_flags = 0;
> +	blk_mq_req_flags_t blk_flags = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;
> +	if (cmd->flags)
> +		return -EINVAL;
> +	if (!nvme_validate_passthru_nsid(ctrl, ns, cmd->nsid))
> +		return -EINVAL;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK) {
> +		rq_flags = REQ_NOWAIT;
> +		blk_flags = BLK_MQ_REQ_NOWAIT;
> +	}
> +	memset(&c, 0, sizeof(c));
> +	c.common.opcode = cmd->opcode;
> +	c.common.flags = cmd->flags;
> +	c.common.nsid = cpu_to_le32(cmd->nsid);
> +	c.common.cdw2[0] = cpu_to_le32(cmd->cdw2);
> +	c.common.cdw2[1] = cpu_to_le32(cmd->cdw3);
> +	c.common.cdw10 = cpu_to_le32(cmd->cdw10);
> +	c.common.cdw11 = cpu_to_le32(cmd->cdw11);
> +	c.common.cdw12 = cpu_to_le32(cmd->cdw12);
> +	c.common.cdw13 = cpu_to_le32(cmd->cdw13);
> +	c.common.cdw14 = cpu_to_le32(cmd->cdw14);
> +	c.common.cdw15 = cpu_to_le32(cmd->cdw15);
> +
> +	req = nvme_alloc_user_request(q, &c, nvme_to_user_ptr(cmd->addr),
> +			cmd->data_len, nvme_to_user_ptr(cmd->metadata),
> +			cmd->metadata_len, 0, cmd->timeout_ms ?
> +			msecs_to_jiffies(cmd->timeout_ms) : 0, 0, rq_flags,
> +			blk_flags);

You need to be careful with reading/re-reading the shared memory. For
example, you do:

	if (!nvme_validate_passthru_nsid(ctrl, ns, cmd->nsid))
		return -EINVAL;

but then later read it again:

	c.common.nsid = cpu_to_le32(cmd->nsid);

What happens if this changes in between the validation and assigning it
here? Either this needs to be a single read and validation, or the
validation doesn't really matter. I'd make this:

	c.common.opcode = READ_ONCE(cmd->opcode);
	c.common.flags = READ_ONCE(cmd->flags);
	c.common.nsid = cpu_to_le32(READ_ONCE(cmd->nsid));
	
	if (!nvme_validate_passthru_nsid(ctrl, ns, le32_to_cpu(c.common.nsid)));
		return -EINVAL;

	c.common.cdw2[0] = cpu_to_le32(READ_ONCE(cmd->cdw2));
	c.common.cdw2[1] = cpu_to_le32(READ_ONCE(cmd->cdw3));
	c.common.metadata = 0;
	memset(&c.common.dptr, 0, sizeof(c.common.dptr));
	c.common.cdw10 = cpu_to_le32(READ_ONCE(cmd->cdw10));
	c.common.cdw11 = cpu_to_le32(READ_ONCE(cmd->cdw11));
	c.common.cdw12 = cpu_to_le32(READ_ONCE(cmd->cdw12));
	c.common.cdw13 = cpu_to_le32(READ_ONCE(cmd->cdw13));
	c.common.cdw14 = cpu_to_le32(READ_ONCE(cmd->cdw14));
	c.common.cdw15 = cpu_to_le32(READ_ONCE(cmd->cdw15));

and then consider the ones passed in to nvme_alloc_user_request() as
well.

-- 
Jens Axboe

