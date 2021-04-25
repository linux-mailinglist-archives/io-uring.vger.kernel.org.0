Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6416B36A850
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 18:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhDYQQH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 12:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230288AbhDYQQH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 12:16:07 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DCCC061574
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 09:15:27 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q10so38497831pgj.2
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 09:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rCFJLAq++O44bIY1f1U8Ky8YHvC2RPh8xvyVRNuQDoY=;
        b=GR6XFHbxsa3yiiXtpL8r4hBS0q/7JCmIDmjt4+A6J1dlrW8q0VHemmWZ7qkY2BwnIM
         rhAgVLlc1rFwnembvLTcAnfz3WZDtZeFnEcX0QYqh6KP+t8cbtmCq1aeYS7hi1uWgbXn
         xJMrD33YCVHhXjdn7kOv3Y9n0OMPagf+o+rOqEXxDfwzDQwvfq/6T+2cZbJjFUMqP/Vx
         zXjswdcTwEgGnCipLN/5+DEc4EARbQzXSmzoltWidfSKiyXuabosFMVr224JrLVqpoIl
         +WEqrjyj9xRorcr8R68+ZzB+DAcwTgUHiKEmPzipF2rARXQH4S1UgJebSNWbLDTlMsJS
         nBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rCFJLAq++O44bIY1f1U8Ky8YHvC2RPh8xvyVRNuQDoY=;
        b=f+S7o76G4DRZ9knWQglFiRsA1uSgAQ0w1PuCHa8BAoYlgpJdzRknv/XWlLhgwMxO4o
         HsSqzaGvASkkUqlXhXTIW0vS4bQZ3yB8bkocTUWnGUwkRysLiBysmwAL4W/hU83g7VDU
         l6pwNBwl/GgDaZTZCxvLuwjQrs4R10KJiIsqJbcAAgr3GY/t6x7+frMUElDtWON00RjC
         eh8pJW6RfuP+SyFldkVCuhknDyj/uhmlApPXq/p8mZ6TJxn40dY33N/bn6rKMOpdAFq8
         oCx4WV5C0p3hJO4QH6UYxk5pFtS1OcWLRBdkF6FpEZr67WzeGGZai4Bo0Y7SuqHwtdNe
         8hMQ==
X-Gm-Message-State: AOAM533DkRk/20AKMrONXLvTItOts9+50ulPxe2q73QkksnUXbYqgVxR
        N4eQRq8TGjluq64AfRmy/lFyMsM4fqgR7w==
X-Google-Smtp-Source: ABdhPJwy0kppkuekeIky+yjRLIOYCDJ/tKnLS4tnyX+dqxoJ+L0FqX96LFehRgBO+4bY/kLQjyOKQA==
X-Received: by 2002:a63:a19:: with SMTP id 25mr13135484pgk.177.1619367326630;
        Sun, 25 Apr 2021 09:15:26 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y193sm9637019pfc.72.2021.04.25.09.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 09:15:26 -0700 (PDT)
Subject: Re: [RFC v2 00/12] dynamic buffers + rsrc tagging
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1619356238.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8bb3e251-e59d-de8c-2dc7-4cde8ea71a37@kernel.dk>
Date:   Sun, 25 Apr 2021 10:15:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/21 7:32 AM, Pavel Begunkov wrote:
> 1) support dynamic managment for registered buffers, including
> update.
> 
> 2) add new IORING_REGISTER* for rsrc register and rsrc update,
> which are just dispatch files/buffers to right callbacks. Needed
> because old ones not nicely extendible. The downside --
> restrictions not supporting it with fine granularity.
> 
> 3) add rsrc tagging, with tag=0 ingnoring CQE posting.
> Doesn't post CQEs on unregister, but can easily be changed
> 
> v2: instead of async_data importing for fixed rw, save
>     used io_mapped_ubuf and use it on re-import.
>     Add patch 9/12 as a preparation for that.
> 
>     Fix prep rw getting a rsrc node ref for fixed files without
>     having a rsrc node.

This looks Good Enough for me, let's get it queued up.

-- 
Jens Axboe

