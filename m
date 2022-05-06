Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA7DA51DB4E
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442542AbiEFPBn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 11:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347628AbiEFPBm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 11:01:42 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB956AA63
        for <io-uring@vger.kernel.org>; Fri,  6 May 2022 07:57:56 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q4so4790114plr.11
        for <io-uring@vger.kernel.org>; Fri, 06 May 2022 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Djq48YgZQsCdnDlnxXNGuTfAQr4XHcZ0oir+uN0p3tU=;
        b=NslQb0mhJEYJPi+avsFd5SUo8tRP/ZVAMPHogekir8T1PauHtWhRZYgXXat0WBDd+Q
         e9Wa7yzoQO41PpNNoaiXG2rlqCDUTVVDzF5SuG4LQOneE7wVrpv6MOAKLInKWi9BJrqj
         tYon4md/oaFzZo4G7dfug/NKl9BHVOsLFZx4dIkFUZV0oR9T295bZ2g0OV82gH9g3Kw+
         71G5/+y+txf3cyjAhIUu5ujX60so7dgKq1FHYhQ6sKV1x27lHr/Yo9wMFgFf3gXPxFkA
         VXzX/WSS6EWRRmVuqcYLfSZ6L/YLfDqFJ5UViYfbjV2safW3sM/Qwdiqc0hDg5ixPHew
         cW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Djq48YgZQsCdnDlnxXNGuTfAQr4XHcZ0oir+uN0p3tU=;
        b=5NTa6eRg5e9Lf1o7YQ3Qu1c3E1EHaG8O592d+9PRk6vAuEFt3wysZe4Ft+i2RW1brZ
         cZeYwBuWcUz+zR9dV1EFhaWqB62AbDuiRcha+4tJBa2UYvToNHNjRK29nlo7s1rIZO4O
         TbOhLfmhzgyce3Ms3bDP8cmmccYsJPC2fBgTx/RkMcpfzjW7XAA248v9mvJY0TTTGnaA
         ml1rjewtNjlLOn7diOkeLRjRbxp/TjVgY5f/IhjfhMYJVbwcyNgn+mGUZGMeblMaQXWy
         +9BOmGYXedHJty2tIOdZgy8RWcdi9cCx2VwgY7r+KxP3k1Yg024qZMEkEacFeR70L81V
         yDAQ==
X-Gm-Message-State: AOAM533kBg3/G/3cjhQHpKyIb/Hv09Xb0lbQmgPeiZ0kQRUEBugTQR8R
        PBvV2dTPd7xCMLeit2dEDaFhvQ==
X-Google-Smtp-Source: ABdhPJyeV9mn1yHYwfhn40dNQD/19QxNzIBhKfPAq7azOse9ud8rzl2hcDs6flBtwAGIJrXjHpbbFg==
X-Received: by 2002:a17:90a:730b:b0:1d9:7fc0:47c5 with SMTP id m11-20020a17090a730b00b001d97fc047c5mr4588862pjk.60.1651849076069;
        Fri, 06 May 2022 07:57:56 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id q9-20020a170902bd8900b0015e8d4eb226sm1842446pls.112.2022.05.06.07.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 07:57:55 -0700 (PDT)
Message-ID: <45b5f76b-b186-e0b9-7b24-e048f73942d5@kernel.dk>
Date:   Fri, 6 May 2022 08:57:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v4 4/5] nvme: wire-up uring-cmd support for io-passthru on
 char-device.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <20220505060616.803816-1-joshi.k@samsung.com>
 <CGME20220505061150epcas5p2b60880c541a4b2f144c348834c7cbf0b@epcas5p2.samsung.com>
 <20220505060616.803816-5-joshi.k@samsung.com>
 <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
 <20220505134256.GA13109@lst.de>
 <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
 <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
 <20220506082844.GA30405@lst.de>
 <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk>
 <20220506145058.GA24077@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220506145058.GA24077@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/6/22 8:50 AM, Christoph Hellwig wrote:
> On Fri, May 06, 2022 at 07:37:55AM -0600, Jens Axboe wrote:
>> Folded most of it, but I left your two meta data related patches as
>> separate as I they really should be separate. However, they need a
>> proper commit message and signed-off-by from you. It's these two:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring-passthrough&id=b855a4458068722235bdf69688448820c8ddae8e
> 
> This one should be folded into "nvme: refactor nvme_submit_user_cmd()",
> which is the patch just before it that adds nvme_meta_from_bio.
> 
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring-passthrough&id=2be698bdd668daeb1aad2ecd516484a62e948547
> 
> Just add this:
> 
> "Add a small helper to act as the counterpart to nvme_add_user_metadata."
> 
> with my signoff:
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Both done, thanks.

>> I did not do your async_size changes, I think you're jetlagged eyes
>> missed that this isn't a sizeof thing on a flexible array, it's just the
>> offset of it. Hence for non-sqe128, the the async size is io_uring_sqe -
>> offsetof where pdu starts, and so forth.
> 
> Hmm, this still seems a bit odd to me.  So without sqe128 you don't even
> get the cmd data that would fit into the 64-bit SQE?

You do. Without sqe128, you get sizeof(sqe) - offsetof(cmd) == 16 bytes.
With, you get 16 + 64, 80.

-- 
Jens Axboe

