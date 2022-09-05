Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A4F5ADB89
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 00:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiIEWvN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Sep 2022 18:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiIEWvM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Sep 2022 18:51:12 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B11C696FE
        for <io-uring@vger.kernel.org>; Mon,  5 Sep 2022 15:51:10 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id l65so9639461pfl.8
        for <io-uring@vger.kernel.org>; Mon, 05 Sep 2022 15:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=E3xYPf23JPbtm6YF37qo9aTQ+xN6eU+OLEyTRQl++XI=;
        b=ttIdF0Zujux2gI/BNxrhH5xNj2Y7JqUANx276p0PZNUOOWn8J4dWzF17a6hj6FRXOI
         oVJmaLQjQ8GmIFLhC4hEWcG+BHaqeMI+A38LjQxyfUcL1MgkrRHoBMkMMqhV345tht/T
         vZNFzDMkGA5Ju2EsWTGiqqz4MdDXLX0j/fEb+MnU15E1yRlZkC++Udn9p13uOtzHCYYz
         ZFrSsQctDIhmSfu9KXLvOVIFjt+UX+7IDE77Ir8oTWF0Pky4BBhdEw4D7gryHafqWRgI
         7Br9OUa0tqKXUnGKD2bXb7N+5w2eFgd6pW1Gw0cHstTUFXG1NRUC4kyKr8uOAcMKzY8H
         umFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=E3xYPf23JPbtm6YF37qo9aTQ+xN6eU+OLEyTRQl++XI=;
        b=Tx4PwfmfMkvspkdw6DCCv7bVV8EV4NOCtNq6dkvKViFE1HH8CP4JZ2fepA+tH5uxvp
         k0836+38+GmXF0ZRgDEbm00qJJ7R2p176YBXvpeS6rmS1VAvQIbFEGyE0RC0gpLXI1wK
         VFtDmeNflBrpxzS0umHk8XrmvOsIRJENaJfla8K8wjpIYFOtEGIfoKKHdM4BLvVa03Op
         hOMqXdxLsvwKMmmPIHBK5nRNDS4bJU/rJBfVc2wx/cdytjSLFZ4eygBoVlb01iTCSXpV
         Fac1HxRpVSi3D3ZRRlwiBQiQlrJ7MNzCsiZEUNFt3oIRPg9+TJbOKxotQe8LRn/YwpLG
         WR4Q==
X-Gm-Message-State: ACgBeo0uNq/WaPE5R8ui2iFcGZuZt26SFLlVgeuvgbcRfnIt8iQ4X+V6
        +bWEb3Cm02C35IiuNA3epdCSU2QWnSl6hQ==
X-Google-Smtp-Source: AA6agR77kvfVstk2PLG5C2tvEpXJbrNUAt0CZUXRwQLIAC9PvvnKjgwqRs8JQ6hp2dWTg7tf6iu23A==
X-Received: by 2002:a05:6a00:23c1:b0:52e:28f5:4e13 with SMTP id g1-20020a056a0023c100b0052e28f54e13mr52350084pfc.20.1662418269846;
        Mon, 05 Sep 2022 15:51:09 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c15-20020a17090a108f00b001fb971bc612sm10938096pja.36.2022.09.05.15.51.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Sep 2022 15:51:09 -0700 (PDT)
Message-ID: <ea903226-581a-c512-f438-b948add1d1a7@kernel.dk>
Date:   Mon, 5 Sep 2022 16:51:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH liburing] man/io_uring_enter.2: document IORING_OP_SEND_ZC
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b56a06f431ea01d125627d4fd95d712e5d72a51c.1662415676.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b56a06f431ea01d125627d4fd95d712e5d72a51c.1662415676.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/5/22 4:09 PM, Pavel Begunkov wrote:
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Doc writing is not my strongest side, comments are welcome.
> 
>  man/io_uring_enter.2 | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
> index 1a9311e..7fd275c 100644
> --- a/man/io_uring_enter.2
> +++ b/man/io_uring_enter.2
> @@ -1059,6 +1059,50 @@ value being passed in. This request type can be used to either just wake or
>  interrupt anyone waiting for completions on the target ring, or it can be used
>  to pass messages via the two fields. Available since 5.18.
>  
> +.TP
> +.B IORING_OP_SEND_ZC
> +Issue the zerocopy equivalent of a
> +.BR send(2)
> +system call. It's similar to IORING_OP_SEND, but when the
> +.I flags
> +field of the
> +.I "struct io_uring_cqe"
> +contains IORING_CQE_F_MORE, the userspace should expect a second cqe, a.k.a.
> +notification, and until then it should not modify data in the buffer. The
> +notification will have the same
> +.I user_data
> +as the first one and its
> +.I flags
> +field will contain the
> +.I IORING_CQE_F_NOTIF
> +flag. It's guaranteed that IORING_CQE_F_MORE is set IFF the result is
> +non-negative.
> +.I fd
> +must be set to the socket file descriptor,
> +.I addr
> +must contain a pointer to the buffer,
> +.I len
> +denotes the length of the buffer to send, and
> +.I msg_flags
> +holds the flags associated with the system call. When
> +.I addr2
> +is non-zero it points to the address of the target with
> +.I addr_len
> +specifying its size, turning the request into a
> +.BR sendto(2)
> +system call equivalent.
> +
> +.B IORING_OP_SEND_ZC
> +tries to avoid making intermediate data copies but still may fall back to
> +copying. Furthermore, zerocopy is not always faster, especially when the
> +per-request payload size is small. The two completion model is needed because
> +the kernel might hold on to buffers for a long time, e.g. waiting for a TCP ACK,
> +and having a separate cqe for request completions allows the userspace to push
> +more data without extra delays. Note, notifications don't guarantee that the
> +data has been or will ever be received by the other endpoint.

I'd probably reorder this a bit to introduce it with the fact that's
it's like SEND, but zero-copy. Then explain the mechanics of how MORE is
set for the 2 stage completion notification if zc is done. I can shuffle
it around a bit if you want me to - just let me know!

> +Available since 5.20.

Should be 6.0 here.

-- 
Jens Axboe
