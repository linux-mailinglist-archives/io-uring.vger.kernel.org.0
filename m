Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC304E5213
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 13:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239152AbiCWMUg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 08:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241074AbiCWMUf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 08:20:35 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4D5F6E8EC
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:19:05 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q19so966951pgm.6
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 05:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:in-reply-to:content-transfer-encoding;
        bh=B5eLCL36NYw/oaCAy7BwB1k2vxjlIgP2L6gnk+5PM+w=;
        b=AgzKJOcIa7lmEYrEZmb8gO5PFNS86uCtEwssFfGTSgpX+W+MVOPT2990nPYqgNCPSg
         WazesvQOyy/KWNpmTmkzQwGja/IypBCD19DU/nGQZ9nMQTwXD++1jki3O+iCP6M/TPej
         c0m2mHxJ4NRzW9QdCtmPb8smcz7L0iYiAzzimFyc8a4H9Mjze3MAN5c1ttGke3rH6jA0
         UCKlYQlLGhGY0cHCzwxvT2klgTQedOXmFWB/RAIJZ6si7i99MZvZuDuDi5c+97jHN5oS
         IUIkxbFHMFPHg6IO/xr+Fnvx5gfB+jJNIDCvT4Cq3Am5J6+AEtCqMIer8GdrYpFWDzNX
         KhOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:in-reply-to
         :content-transfer-encoding;
        bh=B5eLCL36NYw/oaCAy7BwB1k2vxjlIgP2L6gnk+5PM+w=;
        b=MpeTEpizgbzDMyypMRVrB0tEoC853e2nxSwU7z2Vh8kuYbqAnfV88ogUfCv+dsCvcb
         wIILUsGgiV38w2K+FYI82NJzEFOiLRyr+Z1s771D8hb/6l2S62wvpsmQ4pwdHvDshD5p
         O5dkaAFERYvYKBX/7+31K2JqSBqxyBwQ93z5F16RNUPMiDw0EvWL7qMG6AADJ0BP3h45
         El+/0puzGIjaSayPGbMhxkJ+2BuYuXcxBJt0krto6jptl9Aza6QWNnZS1AiL1sIuyM33
         zOn24Iso44iQtL7n7QMecoU4uljnWgdwcjDvnSRBXK8CzXdg4y67s+66bu7+ymlcdhMF
         yQEA==
X-Gm-Message-State: AOAM530mj9Vy5KhvDyvL/CLtv+Odys1XADRVzcS8db2Ze4ScglLwvgMc
        O59rCC+7/dzUNT8vC6U1KgFfPLo0riF758+i
X-Google-Smtp-Source: ABdhPJx1i/SA5mqfLaoa5GFRdvsxuF920HgBhNL/+DR1yaAXnnOWXivQLRoX5SNa+0qn92cI42JhYw==
X-Received: by 2002:a63:5c03:0:b0:382:70fa:4294 with SMTP id q3-20020a635c03000000b0038270fa4294mr13600823pgb.580.1648037945064;
        Wed, 23 Mar 2022 05:19:05 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m19-20020a17090ab79300b001c5ddc6ff21sm5777042pjr.8.2022.03.23.05.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 05:19:04 -0700 (PDT)
Message-ID: <7e6f6467-6ac2-3926-9d7b-09f52f751481@kernel.dk>
Date:   Wed, 23 Mar 2022 06:19:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: io_uring_enter() with opcode IORING_OP_RECV ignores MSG_WAITALL
 in msg_flags
Content-Language: en-US
To:     Constantine Gavrilov <CONSTG@il.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
Cc:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <BYAPR15MB260078EC747F0F0183D1BB1BFA189@BYAPR15MB2600.namprd15.prod.outlook.com>
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

On 3/23/22 4:31 AM, Constantine Gavrilov wrote:
> I get partial receives on TCP socket, even though I specify
> MSG_WAITALL with IORING_OP_RECV opcode. Looking at tcpdump in
> wireshark, I see entire reassambled packet (+4k), so it is not a
> disconnect. The MTU is smaller than 4k.
> 
> From the mailing list history, looks like this was discussed before
> and it seems the fix was supposed to be in. Can someone clarify the
> expected behavior?
> 
> I do not think rsvmsg() has this issue.

Do you have a test case? I added the io-uring list, that's the
appropriate forum for this kind of discussion.

-- 
Jens Axboe

