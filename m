Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79D494BAA11
	for <lists+io-uring@lfdr.de>; Thu, 17 Feb 2022 20:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244835AbiBQTqI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 14:46:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245502AbiBQTqH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 14:46:07 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B497841FB2
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 11:45:52 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q8so5014804iod.2
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 11:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=IomKpjhiE9hCBaljkqkpu7enNEHHs3wNh6F0FbQq59A=;
        b=hWEMBB4EGAJtbUe+d19qICDpUTAe1fyLuuxvrQAbE5+SzGR06k6qxXMOB4574zD633
         TtHdql7mTsXvjT/uAiHfG3aem1y2hQHVKtRKQgCsr5zeZFydVZubhFGT9Pw/B4e5hpSV
         RrEkQDCuW5AWjTG+bdEmzwDVLlzBZkRxGE00Q3bfy/J9ux4U7GUidpjpSxjep0xEUMMQ
         HlZHjeDlARi1CqZmhlNDogIoJHhcWUmo+bYHx0qKOicJigH+o0NI2sTq6XgyCmOkIIQ/
         sIH9N1JF39Skqfb5vEEVj1wmidUGjBdDPvCKp7IQN18X7N711krIvRo9h1OgHlmg2gmO
         eB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IomKpjhiE9hCBaljkqkpu7enNEHHs3wNh6F0FbQq59A=;
        b=Q9fEfXIt1tyo1FFk4GjIQXPjKpUGf7yp+oP1FgWke9CJv+6ocgfXL8dLNoOmjZ2vFK
         JLIVBAyLtxoGj5kCPY2lVbpvaEKy8Rj1gbHd6mjIuR/B2dHL07slgMBw2B93BAnPPkON
         2XKYxl0zoKY81jhkz9r91hUAle1z2hQGXbNGLo+nPl+nP7SZCCqaNmvr9vu7yr8apsy3
         sUmEssd9T2WtvhpkuNNFtcp4HQMU7R25yu9p+DIxuqI2VUtbM3BP4DJS8zD1U1hnrQpe
         z4dgeAricCmo+981EIxbRWcNZw8I3G7Q6T31b0LK90GRl1fi9QAJ0ps2AQLm6Hn0FbOM
         y/WQ==
X-Gm-Message-State: AOAM530H/9QbeGjPf0lnYcZvQM6QZNJh5bTUBwSRooWhN4P6KHfkRe8Q
        NiYMRZwAEfw91DF3eEwW08pSIg==
X-Google-Smtp-Source: ABdhPJwL7FORVQfdFocCkfiY+63OGn9fIVrOZ59yssR/aWrktVptNm0cztWg8icvJrSY/dIe4TAeew==
X-Received: by 2002:a05:6638:34a7:b0:30f:5f87:1fb3 with SMTP id t39-20020a05663834a700b0030f5f871fb3mr2996733jal.219.1645127152032;
        Thu, 17 Feb 2022 11:45:52 -0800 (PST)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s9sm2510132ilv.50.2022.02.17.11.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 11:45:51 -0800 (PST)
Message-ID: <264fb420-26eb-bc0f-b80e-539427093a17@kernel.dk>
Date:   Thu, 17 Feb 2022 12:45:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH 0/3] io_uring: consistent behaviour with linked read/write
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <20220217155815.2518717-1-dylany@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220217155815.2518717-1-dylany@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/17/22 8:58 AM, Dylan Yudaken wrote:
> Currently submitting multiple read/write for one file with IOSQE_IO_LINK
> and offset = -1 will not behave as if calling read(2)/write(2) multiple
> times. The offset may be pinned to the same value for each submission (for
> example if they are punted to the async worker) and so each read/write will
> have the same offset.
> 
> This patchset fixes this by grabbing the file position at execution time,
> rather than when the job is queued to be run.
> 
> A test for this will be submitted to liburing separately.
> 
> Worth noting that this does not purposefully change the result of
> submitting multiple read/write without IOSQE_IO_LINK (for example as in
> [1]). But then I do not know what the correct approach should be when
> submitting multiple r/w without any explicit ordering.
> 
> [1]: https://lore.kernel.org/io-uring/8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk/

I think this series looks great, clean and to the point. My only real
question is one you reference here already, which is the fpos locking
that we really should get done. Care to respin the referenced patch on
top of this series? Would hate to make that part harder...

-- 
Jens Axboe

