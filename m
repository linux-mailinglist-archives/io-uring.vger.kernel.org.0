Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A5E1EC207
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 20:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgFBSma (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 14:42:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgFBSm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 14:42:29 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A2FC08C5C0
        for <io-uring@vger.kernel.org>; Tue,  2 Jun 2020 11:42:29 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 185so5488669pgb.10
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2020 11:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PXMdkD3GPBOdy4TKkm1MRMpxMLSNfOkVsVWMSCIDAqo=;
        b=pfCMSAAG9qdV0Nxo27gg96Rm8FcnE0zYXUSSCFqNm774ceLIl9dRmYBsUyHERF2f6y
         EBEiNStImLOpKpK0uSMSXWOA57BsmGCIJrAsSX/Qlb62FYF6oOCQS4vWxtv7JqWxKGJA
         8pVrm7uV7DNQj7AWPtXgoKFxdqYp4l5O1lpCrc4LTEefRdrKRII4SIWcTaKxtFw8gcaa
         CGVYtg2Unh3RLvlhgW8oFaDZ/fry/HcvumUkahOhV8or9ne/Z4cIzBYGfKxFschxyUwU
         7LDcsrwsSiBMUCa1cpLaIbX3EhGW2prnhfnsz9ghXgcJQInuefXfzed20Om0vXU5Airy
         f/oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PXMdkD3GPBOdy4TKkm1MRMpxMLSNfOkVsVWMSCIDAqo=;
        b=ZaodgB+8c1C1gt8lrL9XeuwTSOK+blDSGXh1QrcIcMrGPJFgJklWdexv08hB5Ezi6K
         fSpwztxDP9Y0IexU6BFQNf6q6pVpBk5xdLRqQW/5vYwzsy8nvL6bb1/kWnqCztsYtTch
         s61xLJf7ErilaAQacLDgVXbR++jaMZxTD5sWiJ8BWSs7/V0bQSJiXYyPjjOIavxLgTT7
         u+cckerYNZ2k0y1PD7pl2sStXUmc9vMWzIhk1VVuE1maPjYtQ6acZXecDHSYIELRiQ7Z
         Zkck2NJc/hPWblX6kgkCnj3jEfzPzF5FjrN00QobFc5pTCu6MIngatvqkq6cbIIJEtmS
         iTBw==
X-Gm-Message-State: AOAM53288HsEXz2VjFcdh41u5NAmc5HPN3XAeaFLh3XqP21EavtMBHQo
        PNozN9a73XWwZ6Y6z0pyJgjkn67yBxuMbg==
X-Google-Smtp-Source: ABdhPJx2MLUfO3JxmoBKaExtlRzA3WAanBdOBRomVvXLHZe4uZamxuL/RgK3TmnQWlgcsFq+vxMaaA==
X-Received: by 2002:a63:4a1d:: with SMTP id x29mr24710025pga.53.1591123348428;
        Tue, 02 Jun 2020 11:42:28 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z18sm3005219pfj.148.2020.06.02.11.42.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jun 2020 11:42:27 -0700 (PDT)
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
To:     Jann Horn <jannh@google.com>
Cc:     Clay Harris <bugs@claycon.org>, io-uring <io-uring@vger.kernel.org>
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <4eaad89b-f6e3-2ff4-af07-f63f7ce35bdc@kernel.dk>
 <CAG48ez1CvEpjNTfOJWBRmR6SVkQjLVeSi2gFvuceR0ubF_HJCQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9c140709-f51f-af35-86c3-68fd02fffb18@kernel.dk>
Date:   Tue, 2 Jun 2020 12:42:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAG48ez1CvEpjNTfOJWBRmR6SVkQjLVeSi2gFvuceR0ubF_HJCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/2/20 12:22 PM, Jann Horn wrote:
> On Sun, May 31, 2020 at 10:19 PM Jens Axboe <axboe@kernel.dk> wrote:
>> We just need this ported to stable once it goes into 5.8-rc:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.8/io_uring&id=904fbcb115c85090484dfdffaf7f461d96fe8e53
> 
> How does that work? Who guarantees that the close operation can't drop
> the refcount of the uring instance to zero before reaching the fdput()
> in io_uring_enter?

Because io_uring_enter() holds a reference to it as well?

-- 
Jens Axboe

