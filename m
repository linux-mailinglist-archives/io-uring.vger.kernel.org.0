Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0793B52346F
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 15:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239492AbiEKNjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 09:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiEKNjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 09:39:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD491BDAED
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:39:08 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 204so2029554pfx.3
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=a5pA5aIxORn31gOeVUCZ7gdchDq/GlpHL8GDXDDRARI=;
        b=rKNaL+SS7CnnjaBYAviIhhQI1e5lSwJ33aHBU+S9tGfgmbis4smAzOt86brGwATbIu
         cCO6km0Bx42c7+pjlMBcYUDVwUcYhZonwnH/ALLEFM3XabiOjitGUJ5H5dmfW5SlbS5T
         FaOe8PuXaPUtplRd1QE8uNBQ0kwoNNL1+AcSyHGg/VVG1MsqI7WolEqdDtm6OslubYOx
         meej5SVJM2Y/rR6sYjQx7hV38yG/ub3qcFfLCY7xPEJsXUdPGyi/H64VwHNc2LMoUmkr
         PFKIpOlyKE7WPleNXD6+rOy17rBpXn1atmqxZYbG1XFkMni8ujSZ//szh2LWIWlxGqRO
         mqzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=a5pA5aIxORn31gOeVUCZ7gdchDq/GlpHL8GDXDDRARI=;
        b=mIul33xLBs1I6c0kAHOd3Rs0x4Lz0JYT+AaurZBQ1aNeNNggCXJtMJuQMp0kbDEcE9
         lJdgwqVcLIrwdfmofjVFO7Fd+m8sffb/G1b4AEs3MboouzCPWlkePMlJ41/AhJ3tZrLz
         XEphr6NcdZNYzuxTsXCRDt2eE2+dv4eIdOO0OPXDGnIOe3OI/NQIGDlqnTcYXbbF4nm7
         0NKl472ymgS0fqJ7I4Bu9Kilv98McaUXWRdr6E7i06X6iL5vNWYh6JZ7UW2ZPNdZOfKu
         uP9poVqWui2LQLNQkLSVXohC5C9k3lsJg6glOWldjp71URLQa/U53ez0VWK3Hjsu1qUd
         akbg==
X-Gm-Message-State: AOAM530vr/LeQFrrvNOmCxnWdNoI+2RjkHpcxFvhm0gEKhqPXLqtIdsU
        KmqJJuq/N7CtoV54gmU96XgiNA==
X-Google-Smtp-Source: ABdhPJwJ3MHxH/51EknoHEeEnx5QcTJ8lYf39MphB2xHMd3lorw0Jx0ugjpXflx6o+rMHN6EgpSHXQ==
X-Received: by 2002:a63:6705:0:b0:3c1:976d:bd68 with SMTP id b5-20020a636705000000b003c1976dbd68mr21140536pgc.133.1652276347591;
        Wed, 11 May 2022 06:39:07 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w186-20020a6230c3000000b0050dc7628134sm1794251pfw.14.2022.05.11.06.39.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 06:39:07 -0700 (PDT)
Message-ID: <9541e45e-76cc-1b62-8f8c-239585354e40@kernel.dk>
Date:   Wed, 11 May 2022 07:39:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v5 0/6] io_uring passthrough for nvme
Content-Language: en-US
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Stefan Roesch <shr@fb.com>, Anuj Gupta <anuj20.g@samsung.com>,
        gost.dev@samsung.com
References: <CGME20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da@epcas5p3.samsung.com>
 <20220511054750.20432-1-joshi.k@samsung.com>
 <b7f8258a-8a63-3e5c-7a1a-d2a0eedf7b00@kernel.dk>
 <CA+1E3rLe0QASNQFMwSjOe-xn_JMzrtG416cAKBTdore+hYYk5g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CA+1E3rLe0QASNQFMwSjOe-xn_JMzrtG416cAKBTdore+hYYk5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/11/22 7:14 AM, Kanchan Joshi wrote:
> On Wed, May 11, 2022 at 6:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Which patches had changes in this series? I'm assuming it's just patch
>> 1, but the changelog doesn't actually say. Would save me from comparing
>> to what's in-tree already.
> 
> Compared to in-tree, it is Patch 1 and Patch 4.
> This part in patch 4:
> +int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
> +               unsigned int issue_flags)
> +{
> +       struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> +       struct nvme_ns_head *head = container_of(cdev, struct
> nvme_ns_head, cdev);
> +       int srcu_idx = srcu_read_lock(&head->srcu);
> +       struct nvme_ns *ns = nvme_find_path(head);
> +       int ret = -EINVAL;
> +
> +       if (ns)
> +               ret = nvme_ns_uring_cmd(ns, ioucmd, issue_flags);
> +       srcu_read_unlock(&head->srcu, srcu_idx);
> +       return ret;
> +}
> Initializing ret to -EINVAL rather than 0.
> We do not support admin commands yet, so ns can be null only if
> something goes wrong with multipath.
> So if at all anything goes wrong and ns is null, it is better to
> return failure than success.
> 
> And I removed the lore links from commit-messages, thinking those will
> be refreshed too.

OK all good, that's what I expected. I'll update the series.

-- 
Jens Axboe

