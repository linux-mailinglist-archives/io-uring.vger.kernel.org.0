Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6401C51FD71
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 14:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiEIM4a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 08:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbiEIM4a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 08:56:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157142608E3
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 05:52:36 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j14so13733183plx.3
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 05:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Wgj59+jDaYn8pUPb9gbkix6V1cj4sjgt4RT2lUhgHw=;
        b=WExzwDCuPqM0R1Mg+wlehzBNlPxfMRSbCaBan+VCx2JwrbY5ZxLOv1Jht9zauHM9vX
         ztRPLqC43v/0jd9XSxXPckHjmmjosgl0sRWj5UT5VBOTrYg9yZGu/mmuIqBOmKV2R5Ep
         gqPosjp86/X/ZaxKlep044CNoma4/44BpEP2kyHrPBhquXobgiD4AJwDy9kNF6PyBszz
         annrdNxRYVU9PXCv8m0L55XBNHQjDX6vL536Ry6pyqWLzXZrAYKg97Um2a1vTHWot4eL
         oE0I3sFd4q3lbOOWnnBZWOrQWiICO7ryHzJt7Qc0YtDjzRprrEh717xXZu9j0FG6ALbx
         B53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Wgj59+jDaYn8pUPb9gbkix6V1cj4sjgt4RT2lUhgHw=;
        b=b9rLWq2/iFE7sSyiwNcuQ8abx8F5S+xc0H+N5La6fI1wXu0j42s63AtddZ4kp476WH
         Foyx566aPs74kv+Y6B1lUPq4bF9xAVSXqQCFs/TKvB6EQWYZgp3ytG0U7zTwQq6O5Qst
         rhYUilc65kNiBR3bpbl7WaMjWJdKOAuASGtSSLnQYkOtKG/OTpJtkWAATd8sW/BIB/Ig
         rKb8Y8JQr4JYnhKcpnqV7OYcS5CcXF5eQQ/WJ04FlLswze88gV26LTgK7y2nRdoc5zll
         9NoMiE1wz6vq/pUnLY17fprI6eyD5eWkIG6xY0mWkdETmuKfDs8lCB1XDrNel6M/4f38
         HduQ==
X-Gm-Message-State: AOAM530vcz+aVUR1fF3bnTZmh1oRWo47Aazg3HWDFJQklvrGn00NST6a
        4YFwqOqaiuyqW4CvQJTTGx+2XQ==
X-Google-Smtp-Source: ABdhPJxkvpN1XB2thsrTILRIMUgiR9LrYgYSLs/QhgnJQA+B/s0XRKMf6Qwm/V2/EGIR8it1lhbspg==
X-Received: by 2002:a17:90b:4acf:b0:1dc:e6f2:dda1 with SMTP id mh15-20020a17090b4acf00b001dce6f2dda1mr14471699pjb.114.1652100755510;
        Mon, 09 May 2022 05:52:35 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f19-20020a17090a639300b001d840f4eee0sm12511993pjj.20.2022.05.09.05.52.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 05:52:34 -0700 (PDT)
Message-ID: <832c42d4-5498-d6dc-7160-c7427e0c52bb@kernel.dk>
Date:   Mon, 9 May 2022 06:52:33 -0600
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
References: <f24d9e5e-34af-9035-ffbc-0a770db0cb20@kernel.dk>
 <20220505134256.GA13109@lst.de>
 <f45c89db-0fed-2c88-e314-71dbda74b4a7@kernel.dk>
 <8ae2c507-ffcc-b693-336d-2d9f907edb76@kernel.dk>
 <20220506082844.GA30405@lst.de>
 <6b0811df-e2a4-22fc-7615-44e5615ce6a4@kernel.dk>
 <20220506145058.GA24077@lst.de>
 <45b5f76b-b186-e0b9-7b24-e048f73942d5@kernel.dk>
 <20220507050317.GA27706@lst.de>
 <d315712a-0792-d15f-040d-3a3922700a53@kernel.dk>
 <20220509060010.GA16939@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20220509060010.GA16939@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/9/22 12:00 AM, Christoph Hellwig wrote:
> On Sat, May 07, 2022 at 06:53:30AM -0600, Jens Axboe wrote:
>> How about we just add a comment? We use it in two spots, but one has
>> knowledge of the sqe64 vs sqe128 state, the other one does not. Hence
>> not sure how best to add a helper for this. One also must be a compile
>> time constant. Best I can think of is the below. Not the prettiest, but
>> it does keep it in one spot and with a single comment rather than in two
>> spots.
> 
> If you think just a comment is better I can live with that, also the
> proposed macro also looks fine to me.

I folded in the macro patch, seems safer and better to just have a
single spot where it's done rather than rely on two comments if things
do change there in the future.

-- 
Jens Axboe

