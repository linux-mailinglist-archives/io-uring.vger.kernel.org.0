Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6104EE117
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 20:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbiCaSxH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 14:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiCaSxF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 14:53:05 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CAB1D08F2
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 11:51:17 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z6so655088iot.0
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 11:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=4v5DRyGnf0vxSmxN7X0VgJqo5Go9H8Zl+asHDT6VjbQ=;
        b=IQQ1YV5GPwEsuc/vUOhuNFn8ZQgFJvwTny3lyO4qK0SELdXf/fyGdOJhW1Iz3GXS42
         PBJ8R4PuDM9LL7NAsWnjZV9wAwQDR3H4CrEM6CmUF9vxNKhWuVnRpSVRJ4kpeoFmfiJv
         rXqoJFhY7mjpqrSw7ZbrDVN/MLRyIihnz8viVoAr2WV1uD2n6cLxPQLhzO497/7IeV05
         WfL+2qxzIRzGHstmtfVfO0MdWlHLgLz/+2IbaxOwJedTmmWuGRKB/TdEZwgbx0Nt5RY8
         dUSGMR8DSG0WltwJoAK6xcc25rB4A/hxnlmtKYEhlnr5fVsCmbQvz9p7BCsrYYC8Ewrk
         OsmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4v5DRyGnf0vxSmxN7X0VgJqo5Go9H8Zl+asHDT6VjbQ=;
        b=c8MS5JvbH/nEvnlMkLbbuIxx6o0eO4hwXMESoGIpNGsFuZkLolKOtNt/BkvINMhbLt
         mSCdUIzty3EHlOfjFxdI6BDLOGJYZBB/dh6xTB0mLwpYQSWhDNZOTPoF7h8ilwbL91B/
         MuWxMbI3czH+Uq231mVpK2Be5kC48ZArAzvIbQincMw7tNeg8B4vZG33qgBp1CKepqE8
         oComWWWhdvatPgO1SsHzV3WsEG8gI5qKshqUmiIRByNh1llz+Ydu3eeI7BsdzfjKp2VZ
         X03eSsxc5FjJCo9tdv8JZqO8flUzgLwVAab7wrPRFjgMpfndnRGVBcl4VG0K07D2/rZd
         AGYA==
X-Gm-Message-State: AOAM533UD92TD85msogg/4TQlKddMYN0DzRlqKqcmg2Wj5RJhyAq2w2w
        lkIBqETKfbESsPV0XjTcTzCHxg==
X-Google-Smtp-Source: ABdhPJxxu1XdfZXFQJau6Elnzbj+jsxNY0DFGaZYuaLBhuhlo5iT0qsSjoJ0DCIxV3Hi//Tisj8gAg==
X-Received: by 2002:a05:6602:154e:b0:649:f21c:9e60 with SMTP id h14-20020a056602154e00b00649f21c9e60mr14917104iow.12.1648752676778;
        Thu, 31 Mar 2022 11:51:16 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a92ab03000000b002c9d9d896eesm110351ilh.68.2022.03.31.11.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 11:51:16 -0700 (PDT)
Message-ID: <7f56f140-ecf0-d72b-b891-171a0aaf21ca@kernel.dk>
Date:   Thu, 31 Mar 2022 12:51:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [syzbot] KASAN: null-ptr-deref Write in io_file_get_normal
Content-Language: en-US
To:     syzbot <syzbot+c4b9303500a21750b250@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <00000000000054c03905db867c20@google.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <00000000000054c03905db867c20@google.com>
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

#syz test: git://git.kernel.dk/linux-block for-next

-- 
Jens Axboe

